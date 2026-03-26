import 'package:basics/PhoneBook/screens/adaptive_layout.dart';
import 'package:flutter/cupertino.dart';

class RolodexApp extends StatelessWidget {
  const RolodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Rolodex',
      theme: CupertinoThemeData(
        barBackgroundColor: Color.fromARGB(255, 92, 92, 92),
      ),
      home: AdaptiveLayout(),
    );
  }
}
