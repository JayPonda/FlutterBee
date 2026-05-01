import 'package:basics/domain/models/contact.dart';

class RecentCall {
  final int id;
  final Contact contact;
  final DateTime calledAt;

  RecentCall({
    required this.id,
    required this.contact,
    required this.calledAt,
  });
}
