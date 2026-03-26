/// Represents a single contact in the phone book
class Contact {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;

  Contact({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
  });

  /// Get the full name of the contact
  String get fullName => '$firstName $lastName';

  /// Get the first letter of the last name for alphabetization
  String get alphabeticalKey => lastName.isNotEmpty
      ? lastName[0].toUpperCase()
      : firstName[0].toUpperCase();

  @override
  String toString() => 'Contact($fullName)';
}
