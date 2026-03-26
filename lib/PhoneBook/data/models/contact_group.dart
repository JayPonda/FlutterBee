import 'contact.dart';

/// Type alias for alphabetized contacts map
/// Maps first letter of last name to list of contacts
typedef AlphabetizedContactMap = Map<String, List<Contact>>;

/// Represents a group/list of contacts
class ContactGroup {
  final int id;
  final String label;
  final String title;
  final List<Contact> contacts;

  ContactGroup({
    required this.id,
    required this.label,
    required this.title,
    required this.contacts,
  });

  /// Returns contacts organized alphabetically by last name
  AlphabetizedContactMap get alphabetizedContacts {
    final Map<String, List<Contact>> grouped = {};

    // Sort contacts by last name
    final sorted = [...contacts]..sort((a, b) => a.lastName.compareTo(b.lastName));

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
