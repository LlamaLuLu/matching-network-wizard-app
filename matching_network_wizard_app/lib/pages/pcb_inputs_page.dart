import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/button_funcs.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';

class PcbInputsPage extends StatefulWidget {
  const PcbInputsPage({super.key});

  @override
  State<PcbInputsPage> createState() => _PcbInputsPageState();
}

class _PcbInputsPageState extends State<PcbInputsPage> {
  final TextEditingController hController = TextEditingController();
  final TextEditingController epsilonRController = TextEditingController();
  final TextEditingController fController = TextEditingController();

  double f = 0;

  @override
  void initState() {
    super.initState();
    setF();
  }

  Future<void> setF() async {
    f = await SavedData.getF();
    f = f / 1e9; // convert to GHz
    setState(() {});
  }

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
                        child: AppWidgets.backButton(context, path: '/results'),
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
                              label: 'h ',
                              controller: hController,
                              hintText: 'Dielectric thickness (1.6 mm)'),
                          AppWidgets.textField(
                              hasSubscript: true,
                              label: '\u03B5',
                              controller: epsilonRController,
                              subscript: 'r',
                              hintText: 'Relative permittivity (4.4)'),
                          AppWidgets.textField(
                              label: 'f  ',
                              controller: fController,
                              hintText:
                                  'Frequency (${f.toStringAsExponential(1)} GHz)'),
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
                    () => ButtonFuncs.pcbInputsBtn(
                        context, hController, epsilonRController),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
