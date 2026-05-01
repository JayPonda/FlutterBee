import 'contact.dart';

/// Type alias for alphabetized contacts map
/// Maps first letter of last name to list of contacts
typedef AlphabetizedContactMap = Map<String, List<Contact>>;

/// Represents a group/list of contacts
class ContactGroup {
  final String id;
  final String label;
  final String title;
  final List<Contact> contacts;

  ContactGroup({
    required this.id,
    required this.label,
    required this.title,
    required this.contacts,
  });

  /// Returns only active (non-deleted) contacts
  List<Contact> get activeContacts =>
      contacts.where((c) => c.deletedAt == null).toList();

  /// Returns contacts organized alphabetically by first name
  AlphabetizedContactMap get alphabetizedContacts {
    final Map<String, List<Contact>> grouped = {};

    // Sort contacts by first name then last name
    final sorted = [...contacts]..sort((a, b) {
        int res = a.firstName.compareTo(b.firstName);
        if (res == 0) res = a.lastName.compareTo(b.lastName);
        return res;
    });

    for (final contact in sorted) {
      final key = contact.alphabeticalKey;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(contact);
    }

    // Return sorted by keys
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  String toString() => 'ContactGroup($label, ${contacts.length} contacts)';
}
