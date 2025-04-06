import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    // output results list
    // circuit diagram
    // graph area (matching network input impedance vs frequency)
    // PCB Design button
    return Scaffold(
      backgroundColor: AppTheme.bg3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // back arrow button
                  AppWidgets.backButton(context),

                  // heading: Results
                  AppWidgets.headingText('Results', AppTheme.text2),
                ],
              ),

              // output results list:
              // use slider carousel of 3 items: parameters, circuit diagram, impedance vs frequency graph

              // temporary placeholder for results
              Expanded(
                child: Container(
                  color: AppTheme.bg1,
                  child: const Center(
                    child: Text(
                      'Results will be displayed here',
                      style: TextStyle(color: AppTheme.text1),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 15),
                child: AppWidgets.appButton(
                    'PCB Design', () => ButtonFuncs.nextBtnResults(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
