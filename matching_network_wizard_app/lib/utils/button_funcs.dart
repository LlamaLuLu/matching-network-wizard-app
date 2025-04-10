import 'dart:math';

import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/calculations.dart';
import 'package:matching_network_wizard_app/utils/saved_data.dart';

// to pass in argument eg:
// () => ButtonFuncs.startBtn(context)

class ButtonFuncs {
  static void regenBtn(BuildContext context, bool pcbMode) async {
    // clear saved data
    await SavedData.clearSavedData();
    if (pcbMode) {
      Navigator.pop(context, '/pcb_inputs');
    } else {
      Navigator.pushNamed(context, '/inputs');
    }
  }

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
    double z0 = double.tryParse(z0Controller.text) ?? 50.0;
    double zLRe = double.tryParse(zLReController.text) ?? 0.0;
    double zLIm = double.tryParse(zLImController.text) ?? 0.0;
    double f = double.tryParse(fController.text) ?? 1.0;
    f *= pow(10, 6);
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
    Navigator.pushNamed(context, '/pcb_inputs');
  }

  static void pcbInputsBtn(
      BuildContext context,
      TextEditingController hController,
      TextEditingController epsilonRController,
      TextEditingController fController) async {
    double h = double.tryParse(hController.text) ?? 1.6; // default for FR4
    h *= pow(10, -3);
    double epsilonR =
        double.tryParse(epsilonRController.text) ?? 4.4; // default for FR4
    double savedF = await SavedData.getF();

    double f = double.tryParse(fController.text) ?? (savedF / pow(10, 6));
    f *= pow(10, 9); // convert to GHz
    debugPrint('Processed PCB Inputs: \n h: $h, epsilonR: $epsilonR');

    await SavedData.savePCBInputsData(h, epsilonR, f);

    Navigator.pushNamed(context, '/pcb');
  }

  // MATCHING NETWORK TYPES:

  static void autoMatchingBtn(BuildContext context) async {
    // if auto-matching -> needs to choose most optimal matching network
    await SavedData.setAutoMode(true);
    await SavedData.checkIfMatched();

    Complex zL = await SavedData.getZL();
    if (zL.imaginary == 0) {
      quarterWaveBtn(context);
      debugPrint('Quarter Wave Transformer Selected');
    } else {
      singleStubBtn(context);
      debugPrint('Auto Matching Network Type Selected');
    }
  }

  static void quarterWaveBtn(BuildContext context) async {
    await SavedData.checkIfMatched();

    await SavedData.setMatchingNetworkType('quarterwave');
    debugPrint('Quarter Wave Transformer Selected');

    // get values
    double z0 = await SavedData.getZ0();
    Complex zL = await SavedData.getZL();
    double zLRe = zL.real;
    // calculate
    double zQWT = Calculations.calcZQWT(z0, zLRe);
    // save result
    await SavedData.setZQWT(zQWT);

    Navigator.pushNamed(context, '/results');
  }

  static void lumpedElementBtn(BuildContext context) async {
    await SavedData.checkIfMatched();

    await SavedData.setMatchingNetworkType('lumped');
    debugPrint('Lumped Element Matching Network Selected');

    // get values
    double z0 = await SavedData.getZ0();
    Complex zL = await SavedData.getZL();
    double zLRe = zL.real;
    double zLIm = zL.imaginary;
    double f = await SavedData.getF();

    // calculate
    List<double> lumpedInside = Calculations.calcLumpedInside(z0, zLRe, zLIm);
    List<double> lumpedOutside = Calculations.calcLumpedOutside(z0, zLRe, zLIm);

    List<double> xA = [lumpedInside[0], lumpedInside[1]];
    List<double> bA = [lumpedInside[2], lumpedInside[3]];
    List<double> xB = [lumpedOutside[0], lumpedOutside[1]];
    List<double> bB = [lumpedOutside[2], lumpedOutside[3]];

    // join all x & b
    List<double> xList = [...xA, ...xB];
    List<double> bList = [...bA, ...bB];
    // calc cap & ind values
    List<double> capIndValues =
        Calculations.calcCapIndValues(bList, xList, z0, f);

    // save result
    await SavedData.saveLumpedData(xA, bA, xB, bB);
    await SavedData.saveCapIndValues(capIndValues);

    Navigator.pushNamed(context, '/results');
  }

  static void singleStubBtn(BuildContext context) async {
    await SavedData.checkIfMatched();

    await SavedData.setMatchingNetworkType('singlestub');
    debugPrint('Single Stub Matching Network Selected');

    // get values
    double z0 = await SavedData.getZ0();
    Complex zL = await SavedData.getZL();
    double zLRe = zL.real;
    double zLIm = zL.imaginary;
    double f = await SavedData.getF();

    // calculate
    List<double> t = Calculations.calcT(z0, zLRe, zLIm);
    List<double> dDivLambda = Calculations.calcDDivLambda(t);
    List<double> b = Calculations.calcBStub(t, z0, zLRe, zLIm);
    List<double> lOpenDivLambda = Calculations.calcLOpenDivLambda(b, z0);
    List<double> lShortDivLambda = Calculations.calcLShortDivLambda(b, z0);

    // save result
    await SavedData.setT(t);
    await SavedData.setDDivLambda(dDivLambda);
    await SavedData.setB(b);
    await SavedData.setLOpenDivLambda(lOpenDivLambda);
    await SavedData.setLShortDivLambda(lShortDivLambda);

    Navigator.pushNamed(context, '/results');
  }
}
