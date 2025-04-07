import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/pages/input_page.dart';
import 'package:matching_network_wizard_app/pages/pcb_inputs_page.dart';
import 'package:matching_network_wizard_app/pages/pcb_page.dart';
import 'package:matching_network_wizard_app/pages/results_page.dart';
import 'package:matching_network_wizard_app/pages/selection_page.dart';
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
        '/start': (context) => StartPage(),
        '/inputs': (context) => InputPage(),
        '/selection': (context) => SelectionPage(),
        '/results': (context) => ResultsPage(),
        '/pcb_inputs': (context) => PcbInputsPage(),
        '/pcb': (context) => PcbPage(),
      },
    );
  }
}
