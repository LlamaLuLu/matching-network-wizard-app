import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController z0Controller = TextEditingController();
  final TextEditingController zLReController = TextEditingController();
  final TextEditingController zLImController = TextEditingController();
  final TextEditingController fController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // textfields for zL, z0, f
    return Scaffold(
      backgroundColor: AppTheme.bg2,
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
                        child: AppWidgets.backButton(context, path: '/start'),
                      ),

                      // heading: Input Parameters
                      Padding(
                        padding: const EdgeInsets.only(top: 35, bottom: 30),
                        child: AppWidgets.headingText(
                            'Input Parameters', AppTheme.text2),
                      ),

                      // input fields
                      Column(
                        children: [
                          AppWidgets.textField(
                              hasSubscript: true,
                              label: 'Z',
                              controller: z0Controller,
                              subscript: '0',
                              hintText: 'Characteristic Impedance (50 \u03A9)'),
                          AppWidgets.textField(
                              hasSubscript: true,
                              label: 'Z',
                              controller: zLReController,
                              subscript: 'L ',
                              hintText: 'REAL Load Impedance'),
                          AppWidgets.textField(
                              hasSubscript: true,
                              label: 'Z',
                              controller: zLImController,
                              subscript: 'L ',
                              hintText: 'IMAGINARY Load Impedance'),
                          AppWidgets.textField(
                            label: 'f   ',
                            controller: fController,
                            hintText: 'Frequency (MHz)',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // next button
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: AppWidgets.pinkButton(
                    'Next',
                    () => ButtonFuncs.nextBtnInputs(
                          context,
                          z0Controller,
                          zLReController,
                          zLImController,
                          fController,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
