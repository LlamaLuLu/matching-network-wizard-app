import 'dart:math';

import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';

// to pass in argument eg:
// () => ButtonFuncs.startBtn(context)

class ButtonFuncs {
  // PAGE NAVIGATION:

  static void startBtn(BuildContext context) {
    Navigator.pushNamed(context, '/inputs');
  }

  static void nextBtnInputs(
    BuildContext context,
    TextEditingController z0Controller,
    TextEditingController zLReController,
    TextEditingController zLImController,
    TextEditingController fController,
  ) async {
    double z0 = double.tryParse(z0Controller.text) ?? 0.0;
    double zLRe = double.tryParse(zLReController.text) ?? 0.0;
    double zLIm = double.tryParse(zLImController.text) ?? 0.0;
    double f = double.tryParse(fController.text) ?? 0.0;
    f *= pow(10, 9);
    debugPrint('Processed Inputs: \nz0: $z0, zLRe: $zLRe, zLIm: $zLIm, f: $f');

    await SavedData.saveInputData(z0, zLRe, zLIm, f);

    // // testing to see if data is saved correctly
    // double savedZ0 = await SavedData.getZ0();
    // Complex savedZL = await SavedData.getZL();
    // double savedF = await SavedData.getF();
    // debugPrint(
    //     'Retrieved Saved Inputs: \nz0: $savedZ0, zL: $savedZL, f: $savedF');

    Navigator.pushNamed(context, '/selection');
  }

  static void pcbBtn(BuildContext context) {
    Navigator.pushNamed(context, '/pcb');
  }

  static void regenBtn(BuildContext context) async {
    // clear saved data
    await SavedData.clearSavedData();
    Navigator.pushNamed(context, '/inputs');
  }

  // MATCHING NETWORK TYPES:

  static void autoMatchingBtn(BuildContext context) async {
    // placeholder for auto matching logic
    // if auto-matching -> needs to choose most optimal matching network
    await SavedData.setMatchingNetworkType('auto');
    debugPrint('Auto Matching Network Type Selected');

    Navigator.pushNamed(context, '/results');
  }

  static void quarterWaveBtn(BuildContext context) async {
    // placeholder for QWT button logic
    await SavedData.setMatchingNetworkType('quarterwave');
    debugPrint('Quarter Wave Transformer Selected');

    Navigator.pushNamed(context, '/results');
  }

  static void lumpedElementBtn(BuildContext context) async {
    // placeholder for lumped element button logic
    await SavedData.setMatchingNetworkType('lumped');
    debugPrint('Lumped Element Matching Network Selected');

    Navigator.pushNamed(context, '/results');
  }

  static void singleStubBtn(BuildContext context) async {
    // placeholder for single stub button logic
    await SavedData.setMatchingNetworkType('singlestub');
    debugPrint('Single Stub Matching Network Selected');

    Navigator.pushNamed(context, '/results');
  }
}
