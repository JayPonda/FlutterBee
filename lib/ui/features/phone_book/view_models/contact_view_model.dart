import 'package:flutter/material.dart';
import 'dart:async';

import 'package:basics/domain/models/contact.dart';
import 'package:basics/domain/models/contact_group.dart';
import 'package:basics/domain/repositories/i_contact_repository.dart';

/// Result of contact validation
class ValidationResult {
  final bool success;
  final String? errorMessage;

  ValidationResult({required this.success, this.errorMessage});
}

/// State management for contact groups
class ContactViewModel extends ChangeNotifier {
  final IContactRepository _repository;
  final listsNotifier = ValueNotifier<List<ContactGroup>>([]);
  StreamSubscription? _subscription;

  IContactRepository get repository => _repository;

  ContactViewModel(this._repository) {
    _listenToRepository();
  }

  void _listenToRepository() {
    _subscription = _repository.watchContactGroups().listen(
      (groups) {
        listsNotifier.value = groups;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Error watching contact groups: ${error.toString()}');
      },
    );
  }

  bool isDeleted(Contact contact) {
    return contact.deletedAt != null;
  }

  Future<void> deleteContact(Contact contact) async {
    try {
      await _repository.deleteContact(contact.id);
    } catch (e) {
      debugPrint('Error deleting contact: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> restoreContact(Contact contact) async {
    try {
      await _repository.restoreContact(contact.id);
    } catch (e) {
      debugPrint('Error restoring contact: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> permanentlyRemove(Contact contact) async {
    try {
      await _repository.permanentlyRemoveContact(contact.id);
    } catch (e) {
      debugPrint('Error permanently removing contact: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> addContact(String groupId, Contact contact) async {
    try {
      debugPrint('Adding contact: ${contact.fullName} to group: $groupId');
      await _repository.insertContact(contact, [groupId]);
    } catch (e) {
      debugPrint('Error adding contact: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> removeContact(String groupId, Contact contact) async {
    try {
      // In this implementation, removeContact from group might mean deleting it
      // or just removing the association. The repository doesn't have a specific
      // method for removing from group yet, so we'll just delete for now or
      // we could add it to the repository.
      await _repository.deleteContact(contact.id);
    } catch (e) {
      debugPrint('Error removing contact: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await _repository.updateContact(contact);
    } catch (e) {
      debugPrint('Error updating contact: ${e.toString()}');
      rethrow;
    }
  }

  ContactGroup findContactList(String listId) {
    return listsNotifier.value.firstWhere(
      (group) => group.id == listId,
      orElse: () => listsNotifier.value.first,
    );
  }

  ValidationResult validateContact(Contact contact, {String? excludeId}) {
    // 1. Required Fields
    if (contact.firstName.trim().isEmpty || contact.lastName.trim().isEmpty) {
      return ValidationResult(
        success: false,
        errorMessage: 'First and last name are required',
      );
    }

    if (contact.phoneNumber == null || contact.phoneNumber!.trim().isEmpty) {
      return ValidationResult(
        success: false,
        errorMessage: 'Phone number is required',
      );
    }

    // 2. Length Validations
    if (contact.firstName.length > 30 || contact.lastName.length > 30) {
      return ValidationResult(
        success: false,
        errorMessage: 'Name must be 30 characters or less',
      );
    }

    final phone = contact.phoneNumber!.trim();
    if (phone.length < 6 || phone.length > 15) {
      return ValidationResult(
        success: false,
        errorMessage: 'Phone number must be between 6 and 15 digits',
      );
    }

    if (contact.email != null && contact.email!.length > 250) {
      return ValidationResult(
        success: false,
        errorMessage: 'Email must be 250 characters or less',
      );
    }

    // 3. Duplicate Checks (Excluding soft-deleted contacts)
    final allGroups = listsNotifier.value;
    for (final group in allGroups) {
      for (final existing in group.contacts) {
        // Skip soft-deleted records
        if (existing.deletedAt != null) continue;
        
        // Skip if it's the same contact we're editing
        if (excludeId != null && existing.id == excludeId) continue;

        // Duplicate Name Check
        if (existing.firstName.toLowerCase() ==
                contact.firstName.toLowerCase() &&
            existing.lastName.toLowerCase() == contact.lastName.toLowerCase()) {
          return ValidationResult(
            success: false,
            errorMessage: '${contact.firstName} ${contact.lastName} already exists',
          );
        }

        // Duplicate Phone Check
        if (existing.phoneNumber == contact.phoneNumber) {
          return ValidationResult(
            success: false,
            errorMessage:
                'This phone number is already in use by ${existing.fullName}',
          );
        }
      }
    }

    return ValidationResult(success: true);
  }

  Future<ValidationResult> updateContactWithValidation(
    Contact oldContact,
    Contact newContact, {
    String? newGroupId,
  }) async {
    try {
      final validation = validateContact(newContact, excludeId: oldContact.id);
      if (!validation.success) return validation;

      await _repository.updateContact(newContact);
      if (newGroupId != null) {
        await _repository.updateContactGroups(newContact.id, [newGroupId]);
      }
      return ValidationResult(success: true);
    } catch (e) {
      debugPrint('Error in updateContactWithValidation: ${e.toString()}');
      return ValidationResult(
        success: false,
        errorMessage: 'Database error: ${e.toString()}',
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    listsNotifier.dispose();
    super.dispose();
  }
}
