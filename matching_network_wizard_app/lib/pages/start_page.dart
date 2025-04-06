import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // heading: Matching Network Wizard
              Padding(
                padding: const EdgeInsets.only(top: 185),
                child: const Text(
                  'Matching Network Wizard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text3,
                  ),
                ),
              ),

              // start button
              Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: AppWidgets.appButton(
                    'Start', () => ButtonFuncs.startBtn(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
