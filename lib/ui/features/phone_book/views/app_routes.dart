import 'package:flutter/cupertino.dart';

import 'package:basics/domain/models/contact.dart';
import 'adaptive_layout.dart';
import 'contact_detail.dart';

/// Route names for the application
/// Using named routes as demonstrated in the Flutter navigation tutorial
class AppRoutes {
  static const String home = '/';
  static const String contactDetail = '/contact-detail';
}

/// Route generator function for named routes
/// This maps route names to their corresponding pages
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return CupertinoPageRoute<void>(
        builder: (_) => const AdaptiveLayout(),
        settings: settings,
      );

    case AppRoutes.contactDetail:
      // Extract the contact from arguments
      final contact = settings.arguments as Contact;
      return CupertinoPageRoute<void>(
        builder: (_) => ContactDetailPage(contact: contact),
        settings: settings,
      );

    default:
      return CupertinoPageRoute<void>(
        builder: (_) => const AdaptiveLayout(),
        settings: settings,
      );
  }
}
