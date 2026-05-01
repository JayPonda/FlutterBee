import 'package:drift/drift.dart';
import 'package:basics/data/database/app_database.dart';
import 'package:basics/domain/models/contact.dart';
import 'package:basics/domain/models/contact_group.dart';
import 'package:basics/domain/repositories/i_contact_repository.dart';

class DriftContactRepository implements IContactRepository {
  final AppDatabase _db;

  DriftContactRepository(this._db);

  @override
  Stream<List<ContactGroup>> watchContactGroups() async* {
    // Emit initial data
    yield await _fetchContactGroupsInternal();

    // Then emit whenever tables change
    await for (final _ in _db.tableUpdates()) {
      yield await _fetchContactGroupsInternal();
    }
  }

  Future<List<ContactGroup>> _fetchContactGroupsInternal() async {
    try {
      final groups = await _db.select(_db.groups).get();
      final List<ContactGroup> contactGroups = [];

      for (final group in groups) {
        final List<Contact> contacts;

        if (group.id == '0') {
          // Special case for "All Contacts" group: fetch every contact in the database
          final allEntries = await _db.select(_db.contacts).get();
          contacts = allEntries.map(_mapContactEntryToDomain).toList();
        } else {
          // Fetch contacts specifically associated with this group
          final contactsInGroup = await (_db.select(_db.contacts).join([
            innerJoin(
              _db.contactToGroup,
              _db.contactToGroup.contactId.equalsExp(_db.contacts.id),
            ),
          ])..where(_db.contactToGroup.groupId.equals(group.id)))
              .get();

          contacts = contactsInGroup.map((row) {
            final entry = row.readTable(_db.contacts);
            return _mapContactEntryToDomain(entry);
          }).toList();
        }

        contactGroups.add(ContactGroup(
          id: group.id,
          label: group.label,
          title: group.title,
          contacts: contacts,
        ));
      }
      return contactGroups;
    } catch (e, stack) {
      print('Error in _fetchContactGroupsInternal: $e');
      print(stack);
      rethrow;
    }
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
  Future<void> updateContactGroups(String contactId, List<String> groupIds) async {
    await _db.transaction(() async {
      // Clear existing associations
      await (_db.delete(_db.contactToGroup)
            ..where((t) => t.contactId.equals(contactId)))
          .go();
      
      // Add new associations
      for (final groupId in groupIds) {
        await _db.into(_db.contactToGroup).insert(
          ContactToGroupCompanion.insert(
            contactId: contactId,
            groupId: groupId,
          ),
        );
      }
    });
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
