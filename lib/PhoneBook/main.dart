import 'package:basics/PhoneBook/screens/app_routes.dart';
import 'package:basics/PhoneBook/screens/adaptive_layout.dart';
import 'package:flutter/cupertino.dart';

class RolodexApp extends StatelessWidget {
  const RolodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Rolodex',
      theme: const CupertinoThemeData(
        barBackgroundColor: Color.fromARGB(255, 92, 92, 92),
      ),
      // Configure named routes
      onGenerateRoute: generateRoute,
      // Set initial route
      initialRoute: AppRoutes.home,
      home: const AdaptiveLayout(),
    );
  }
}
