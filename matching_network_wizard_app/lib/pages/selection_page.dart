import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // cards for 3 types & auto matching
    return Scaffold(
      backgroundColor: AppTheme.bg2,
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

                  // heading: Selection
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 25),
                    child: AppWidgets.headingText(
                        'Matching Network Selection', AppTheme.text2),
                  ),
                ],
              ),
              Expanded(
                child: AppWidgets.networkTypeCard(
                    'Auto-Matching',
                    () => ButtonFuncs.autoMatchingBtn(context),
                    AppTheme.text1,
                    AppTheme.bg1),
              ),
              Expanded(
                child: AppWidgets.networkTypeCard(
                    'Quarter Wave Transformer',
                    () => ButtonFuncs.quarterWaveBtn(context),
                    AppTheme.text4,
                    AppTheme.bg4),
              ),
              Expanded(
                child: AppWidgets.networkTypeCard(
                    'Lumped Element\nMatching Network',
                    () => ButtonFuncs.lumpedElementBtn(context),
                    AppTheme.text3,
                    AppTheme.bg3),
              ),
              Expanded(
                child: AppWidgets.networkTypeCard(
                    'Single-Stub\nMatching Network',
                    () => ButtonFuncs.singleStubBtn(context),
                    AppTheme.text5,
                    AppTheme.bg5),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
