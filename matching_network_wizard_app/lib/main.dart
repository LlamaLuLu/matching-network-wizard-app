import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matching Network Wizard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: StartPage(),
      routes: {
        '/home': (context) => StartPage(),
      },
    );
  }
}
