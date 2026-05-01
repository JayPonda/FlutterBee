import 'package:basics/domain/models/contact.dart';
import 'package:basics/domain/models/contact_group.dart';
import 'package:basics/domain/models/recent_call.dart';

abstract class IContactRepository {
  Stream<List<ContactGroup>> watchContactGroups();
  Future<void> insertContact(Contact contact, List<String> groupIds);
  Future<void> updateContact(Contact contact);
  Future<void> updateContactGroups(String contactId, List<String> groupIds);
  Future<void> deleteContact(String contactId);
  Future<void> restoreContact(String contactId);
  Future<void> permanentlyRemoveContact(String contactId);
  
  Future<void> insertGroup(ContactGroup group);
  Future<void> deleteGroup(String groupId);

  Stream<List<RecentCall>> watchRecentCalls();
  Future<void> addRecentCall(String contactId);
}
