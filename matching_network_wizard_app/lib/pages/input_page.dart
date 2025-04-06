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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // back arrow button
                  AppWidgets.backButton(context, '/start'),

                  // heading: Input Parameters
                  AppWidgets.headingText('Input Parameters', AppTheme.text2),

                  // input fields
                  Column(
                    children: [
                      AppWidgets.textField(
                          hasSubscript: true,
                          label: 'Z',
                          controller: z0Controller,
                          subscript: '0',
                          hintText: 'Source Impedance'),
                      AppWidgets.textField(
                          hasSubscript: true,
                          label: 'Z',
                          controller: zLReController,
                          subscript: 'L ',
                          hintText: 'Real Load Impedance'),
                      AppWidgets.textField(
                          hasSubscript: true,
                          label: 'Z',
                          controller: zLImController,
                          subscript: 'L ',
                          hintText: 'Imaginary Load Impedance'),
                      AppWidgets.textField(
                        label: 'f   ',
                        controller: fController,
                        hintText: 'Frequency (GHz)',
                      ),
                    ],
                  ),
                ],
              ),

              // next button
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: AppWidgets.appButton(
                    'Next', () => ButtonFuncs.nextBtnInputs(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
