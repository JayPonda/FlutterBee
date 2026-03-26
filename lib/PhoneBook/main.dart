import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.amberAccent.shade400,
          onPrimary: Colors.amberAccent.shade700,
          secondary: Colors.cyan.shade300,
          onSecondary: Colors.cyan.shade400,
          error: Colors.red.shade600,
          onError: Colors.orange.shade900,
          surface: Colors.grey.shade400,
          onSurface: Colors.grey.shade600,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Title bar for the widgit",
            style: TextStyle(
              letterSpacing: 2,
              color: Colors.blueGrey.shade800,
              fontWeight: FontWeight(800),
              fontStyle: FontStyle.normal,
            ),
          ),
          iconTheme: IconThemeData(
            size: 8.5,
            color: Colors.deepOrangeAccent.shade400,
          ),
          backgroundColor: Colors.amberAccent.shade200,
        ),
        body: Center(
          child: Text(
            'here the content of the phonebook',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight(800),
              shadows: List.generate(
                10,
                (int shadow) => Shadow(
                  color: Colors.brown,
                  blurRadius: 20,
                  offset: Offset(5, 5),
                ),
                growable: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
