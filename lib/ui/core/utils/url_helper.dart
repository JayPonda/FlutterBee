import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class UrlHelper {
  /// Launches a phone call to the specified [phoneNumber].
  /// Sanitizes the input by removing non-numeric characters (except '+').
  static Future<void> makeCall(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: sanitizedNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Could not launch $launchUri');
      }
    } catch (e) {
      debugPrint('Error launching call: $e');
    }
  }
}
