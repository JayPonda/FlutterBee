import '../models/contact.dart';
import '../models/contact_group.dart';

abstract class IContactRepository {
  Stream<List<ContactGroup>> watchContactGroups();
  Future<void> insertContact(Contact contact, List<String> groupIds);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
  Future<void> restoreContact(String contactId);
  Future<void> permanentlyRemoveContact(String contactId);
  
  Future<void> insertGroup(ContactGroup group);
  Future<void> deleteGroup(String groupId);
}
