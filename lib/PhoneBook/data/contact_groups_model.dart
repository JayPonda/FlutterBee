import 'package:flutter/material.dart';

import 'models/contact.dart';
import 'models/contact_group.dart';

/// Result of contact validation
class ValidationResult {
  final bool success;
  final String? errorMessage;

  ValidationResult({required this.success, this.errorMessage});
}

/// Global state management for contact groups
class ContactGroupsModel {
  final listsNotifier = ValueNotifier<List<ContactGroup>>([]);
  final _sessionDeletedContacts = <Contact>{};

  ContactGroupsModel() {
    _initializeDummyData();
  }

  bool isDeleted(Contact contact) {
    return _sessionDeletedContacts.contains(contact);
  }

  void deleteContact(Contact contact) {
    for (final group in listsNotifier.value) {
      if (group.contacts.contains(contact)) {
        group.contacts.remove(contact);
        final deletedContact = contact.copyWith(deletedAt: DateTime.now());
        _sessionDeletedContacts.add(deletedContact);
        _notifyListeners();
        return;
      }
    }
  }

  void restoreContact(Contact contact) {
    final iterator = _sessionDeletedContacts.iterator;
    Contact? toRestore;
    while (iterator.moveNext()) {
      if (iterator.current.fullName == contact.fullName) {
        toRestore = iterator.current;
        break;
      }
    }
    if (toRestore != null) {
      _sessionDeletedContacts.remove(toRestore);
      final restoredContact = toRestore.copyWith(deletedAt: null);
      if (listsNotifier.value.isNotEmpty) {
        listsNotifier.value.first.contacts.add(restoredContact);
      }
      _notifyListeners();
    }
  }

  void permanentlyRemove(Contact contact) {
    _sessionDeletedContacts.removeWhere((c) => c.fullName == contact.fullName);
  }

  void addContact(int groupId, Contact contact) {
    final group = findContactList(groupId);
    group.contacts.add(contact);
    _notifyListeners();
  }

  void removeContact(int groupId, Contact contact) {
    final group = findContactList(groupId);
    group.contacts.remove(contact);
    _notifyListeners();
  }

  void updateContact(int groupId, Contact oldContact, Contact newContact) {
    final group = findContactList(groupId);
    final index = group.contacts.indexOf(oldContact);
    if (index != -1) {
      group.contacts[index] = newContact;
      _notifyListeners();
    }
  }

  ContactGroup findContactList(int listId) {
    return listsNotifier.value.firstWhere(
      (group) => group.id == listId,
      orElse: () => listsNotifier.value.first,
    );
  }

  void removeContactByRef(Contact contact) {
    for (final group in listsNotifier.value) {
      if (group.contacts.contains(contact)) {
        group.contacts.remove(contact);
        _notifyListeners();
        return;
      }
    }
  }

  ValidationResult updateContactWithValidation(
    Contact oldContact,
    Contact newContact,
  ) {
    for (final group in listsNotifier.value) {
      for (final existing in group.contacts) {
        if (existing == oldContact) continue;

        if (existing.phoneNumber != null &&
            newContact.phoneNumber != null &&
            existing.phoneNumber == newContact.phoneNumber &&
            existing.fullName.toLowerCase() !=
                newContact.fullName.toLowerCase()) {
          return ValidationResult(
            success: false,
            errorMessage:
                'Phone number already belongs to ${existing.fullName}',
          );
        }

        if (existing.phoneNumber != null &&
            newContact.phoneNumber != null &&
            existing.fullName.toLowerCase() ==
                newContact.fullName.toLowerCase() &&
            existing.phoneNumber != newContact.phoneNumber) {
          return ValidationResult(
            success: false,
            errorMessage:
                '${newContact.fullName} already exists with a different phone number',
          );
        }
      }
    }

    for (final group in listsNotifier.value) {
      final index = group.contacts.indexOf(oldContact);
      if (index != -1) {
        group.contacts[index] = newContact;
        _notifyListeners();
        return ValidationResult(success: true);
      }
    }
    return ValidationResult(success: false, errorMessage: 'Contact not found');
  }

  void _notifyListeners() {
    listsNotifier.value = [...listsNotifier.value];
  }

  void dispose() {
    listsNotifier.dispose();
  }

  void _initializeDummyData() {
    listsNotifier.value = [
      ContactGroup(
        id: 0,
        label: 'All Contacts',
        title: 'All Contacts',
        contacts: [
          Contact(
            firstName: 'Alice',
            lastName: 'Anderson',
            phoneNumber: '555-0101',
            email: 'alice@example.com',
          ),
          Contact(
            firstName: 'Bob',
            lastName: 'Brown',
            phoneNumber: '555-0102',
            email: 'bob@example.com',
          ),
          Contact(
            firstName: 'Charlie',
            lastName: 'Chapman',
            phoneNumber: '555-0103',
            email: 'charlie@example.com',
          ),
          Contact(
            firstName: 'Diana',
            lastName: 'Davis',
            phoneNumber: '555-0104',
            email: 'diana@example.com',
          ),
          Contact(
            firstName: 'Eve',
            lastName: 'Evans',
            phoneNumber: '555-0105',
            email: 'eve@example.com',
          ),
          Contact(
            firstName: 'Frank',
            lastName: 'Foster',
            phoneNumber: '555-0106',
            email: 'frank@example.com',
          ),
          Contact(
            firstName: 'Grace',
            lastName: 'Green',
            phoneNumber: '555-0107',
            email: 'grace@example.com',
          ),
          Contact(
            firstName: 'Henry',
            lastName: 'Harris',
            phoneNumber: '555-0108',
            email: 'henry@example.com',
          ),
          Contact(
            firstName: 'Iris',
            lastName: 'Iverson',
            phoneNumber: '555-0109',
            email: 'iris@example.com',
          ),
          Contact(
            firstName: 'Jack',
            lastName: 'Johnson',
            phoneNumber: '555-0110',
            email: 'jack@example.com',
          ),
        ],
      ),
      ContactGroup(
        id: 1,
        label: 'Friends',
        title: 'Friends',
        contacts: [
          Contact(
            firstName: 'Alex',
            lastName: 'Adams',
            phoneNumber: '555-0201',
            email: 'alex@example.com',
          ),
          Contact(
            firstName: 'Bailey',
            lastName: 'Bennett',
            phoneNumber: '555-0202',
            email: 'bailey@example.com',
          ),
          Contact(
            firstName: 'Casey',
            lastName: 'Carter',
            phoneNumber: '555-0203',
            email: 'casey@example.com',
          ),
          Contact(
            firstName: 'Dana',
            lastName: 'Dixon',
            phoneNumber: '555-0204',
            email: 'dana@example.com',
          ),
          Contact(
            firstName: 'Elliot',
            lastName: 'Edwards',
            phoneNumber: '555-0205',
            email: 'elliot@example.com',
          ),
        ],
      ),
      ContactGroup(
        id: 2,
        label: 'Family',
        title: 'Family',
        contacts: [
          Contact(
            firstName: 'Fiona',
            lastName: 'Fisher',
            phoneNumber: '555-0301',
            email: 'fiona@example.com',
          ),
          Contact(
            firstName: 'George',
            lastName: 'Garcia',
            phoneNumber: '555-0302',
            email: 'george@example.com',
          ),
          Contact(
            firstName: 'Hannah',
            lastName: 'Holmes',
            phoneNumber: '555-0303',
            email: 'hannah@example.com',
          ),
          Contact(
            firstName: 'Isaac',
            lastName: 'Ingram',
            phoneNumber: '555-0304',
            email: 'isaac@example.com',
          ),
        ],
      ),
      ContactGroup(
        id: 3,
        label: 'Work',
        title: 'Work Colleagues',
        contacts: [
          Contact(
            firstName: 'Julia',
            lastName: 'James',
            phoneNumber: '555-0401',
            email: 'julia@example.com',
          ),
          Contact(
            firstName: 'Kevin',
            lastName: 'King',
            phoneNumber: '555-0402',
            email: 'kevin@example.com',
          ),
          Contact(
            firstName: 'Laura',
            lastName: 'Lewis',
            phoneNumber: '555-0403',
            email: 'laura@example.com',
          ),
          Contact(
            firstName: 'Michael',
            lastName: 'Miller',
            phoneNumber: '555-0404',
            email: 'michael@example.com',
          ),
          Contact(
            firstName: 'Nancy',
            lastName: 'Nelson',
            phoneNumber: '555-0405',
            email: 'nancy@example.com',
          ),
          Contact(
            firstName: 'Oliver',
            lastName: 'Owen',
            phoneNumber: '555-0406',
            email: 'oliver@example.com',
          ),
        ],
      ),
    ];
  }
}

final contactGroupsModel = ContactGroupsModel();
