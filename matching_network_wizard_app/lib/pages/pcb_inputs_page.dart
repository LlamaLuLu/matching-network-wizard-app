import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

class PcbInputsPage extends StatefulWidget {
  const PcbInputsPage({super.key});

  @override
  State<PcbInputsPage> createState() => _PcbInputsPageState();
}

class _PcbInputsPageState extends State<PcbInputsPage> {
  final TextEditingController wController = TextEditingController();
  final TextEditingController hController = TextEditingController();
  final TextEditingController epsilonRController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg5,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // back arrow button
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: AppWidgets.backButton(context),
                      ),

                      // heading: Input Parameters
                      Padding(
                        padding: const EdgeInsets.only(top: 35, bottom: 40),
                        child: AppWidgets.headingText(
                            'PCB Design Inputs', AppTheme.text5),
                      ),

                      // input fields
                      Column(
                        children: [
                          AppWidgets.textField(
                              label: 'w',
                              controller: wController,
                              hintText: 'Track width (mm)'),
                          AppWidgets.textField(
                              label: 'h ',
                              controller: hController,
                              hintText: 'Dielectric thickness (mm)'),
                          AppWidgets.textField(
                              hasSubscript: true,
                              label: '\u03B5',
                              controller: epsilonRController,
                              subscript: 'r',
                              hintText: 'Relative permittivity'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // next button
              Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: AppWidgets.pinkButton(
                    'Next',
                    () => ButtonFuncs.pcbInputsBtn(
                        context, wController, hController, epsilonRController),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
