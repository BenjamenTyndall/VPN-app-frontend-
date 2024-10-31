
import 'package:flutter/material.dart';
import 'package:firstapp/pages/login.dart'; // Import the file where LoginApp is defined
import 'package:firstapp/pages/home.dart'; // Import the file where HomePage is defined
import 'package:firstapp/pages/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Virtual Pirate Network",
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginApp(),
        '/home': (context) => HomePage(),
        '/menu': (context) => MenuPage(),
      },
    );
  }
}
