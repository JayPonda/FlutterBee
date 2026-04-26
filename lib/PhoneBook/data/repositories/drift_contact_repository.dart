import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/contact.dart';
import '../models/contact_group.dart';
import 'i_contact_repository.dart';

class DriftContactRepository implements IContactRepository {
  final AppDatabase _db;

  DriftContactRepository(this._db);

  @override
  Stream<List<ContactGroup>> watchContactGroups() {
    // We want to trigger a refresh whenever any of these tables change.
    // By joining all three tables in the watched query, Drift will notify
    // us if any of them are modified.
    final triggerQuery = _db.select(_db.groups).join([
      leftOuterJoin(
        _db.contactToGroup,
        _db.contactToGroup.groupId.equalsExp(_db.groups.id),
      ),
      leftOuterJoin(
        _db.contacts,
        _db.contacts.id.equalsExp(_db.contactToGroup.contactId),
      ),
    ]);

    return triggerQuery.watch().asyncMap((_) async {
      final groups = await _db.select(_db.groups).get();
      final List<ContactGroup> contactGroups = [];

      for (final group in groups) {
        final contactsInGroup = await (_db.select(_db.contacts).join([
          innerJoin(
            _db.contactToGroup,
            _db.contactToGroup.contactId.equalsExp(_db.contacts.id),
          ),
        ])..where(_db.contactToGroup.groupId.equals(group.id)))
            .get();

        final contacts = contactsInGroup.map((row) {
          final entry = row.readTable(_db.contacts);
          return _mapContactEntryToDomain(entry);
        }).toList();

        contactGroups.add(ContactGroup(
          id: group.id,
          label: group.label,
          title: group.title,
          contacts: contacts,
        ));
      }
      return contactGroups;
    });
  }

  @override
  Future<void> insertContact(Contact contact, List<String> groupIds) async {
    await _db.transaction(() async {
      await _db.into(_db.contacts).insert(
        ContactsCompanion.insert(
          id: Value(contact.id),
          firstName: contact.firstName,
          lastName: contact.lastName,
          phoneNumber: Value(contact.phoneNumber),
          email: Value(contact.email),
          deletedAt: Value(contact.deletedAt),
        ),
      );

      for (final groupId in groupIds) {
        await _db.into(_db.contactToGroup).insert(
          ContactToGroupCompanion.insert(
            contactId: contact.id,
            groupId: groupId,
          ),
        );
      }
    });
  }

  @override
  Future<void> updateContact(Contact contact) async {
    await (_db.update(_db.contacts)
          ..where((t) => t.id.equals(contact.id)))
        .write(ContactsCompanion(
      firstName: Value(contact.firstName),
      lastName: Value(contact.lastName),
      phoneNumber: Value(contact.phoneNumber),
      email: Value(contact.email),
      deletedAt: Value(contact.deletedAt),
    ));
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await (_db.update(_db.contacts)
          ..where((t) => t.id.equals(contactId)))
        .write(ContactsCompanion(
      deletedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> restoreContact(String contactId) async {
    await (_db.update(_db.contacts)
          ..where((t) => t.id.equals(contactId)))
        .write(const ContactsCompanion(
      deletedAt: Value(null),
    ));
  }

  @override
  Future<void> permanentlyRemoveContact(String contactId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.contactToGroup)
            ..where((t) => t.contactId.equals(contactId)))
          .go();
      await (_db.delete(_db.contacts)
            ..where((t) => t.id.equals(contactId)))
          .go();
    });
  }

  @override
  Future<void> insertGroup(ContactGroup group) async {
    await _db.into(_db.groups).insert(
      GroupEntry(
        id: group.id,
        label: group.label,
        title: group.title,
      ),
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.contactToGroup)
            ..where((t) => t.groupId.equals(groupId)))
          .go();
      await (_db.delete(_db.groups)
            ..where((t) => t.id.equals(groupId)))
          .go();
    });
  }

  Contact _mapContactEntryToDomain(ContactEntry entry) {
    return Contact(
      id: entry.id,
      firstName: entry.firstName,
      lastName: entry.lastName,
      phoneNumber: entry.phoneNumber,
      email: entry.email,
      deletedAt: entry.deletedAt,
    );
  }
}
