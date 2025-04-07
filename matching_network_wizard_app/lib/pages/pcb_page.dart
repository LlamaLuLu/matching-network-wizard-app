import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';

class PcbPage extends StatefulWidget {
  const PcbPage({super.key});

  @override
  State<PcbPage> createState() => _PcbPageState();
}

class _PcbPageState extends State<PcbPage> {
  @override
  Widget build(BuildContext context) {
    // inputs for epsilon_r, height, width, length, and thickness
    // output area
    return Scaffold(
      backgroundColor: AppTheme.bg5,
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

                  // heading: PCB Design
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: AppWidgets.headingText('PCB Design', AppTheme.text2),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: AppTheme.bg1,
                  child: const Center(
                    child: Text(
                      'PCB Design will be displayed here',
                      style: TextStyle(color: AppTheme.text1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 15),
        child: FloatingActionButton(
          onPressed: () {
            // Add your action here
          },
          backgroundColor: AppTheme.bg2,
          foregroundColor: AppTheme.text2,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
