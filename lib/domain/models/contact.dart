/// Represents a single contact in the phone book
class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final DateTime? deletedAt;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.deletedAt,
  });

  Contact copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    DateTime? deletedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Get the full name of the contact
  String get fullName => '$firstName $lastName';

  /// Get the first letter of the first name (or last name if first is missing) for alphabetization
  String get alphabeticalKey => firstName.isNotEmpty
      ? firstName[0].toUpperCase()
      : (lastName.isNotEmpty ? lastName[0].toUpperCase() : '?');

  @override
  String toString() => 'Contact($fullName)';
}
