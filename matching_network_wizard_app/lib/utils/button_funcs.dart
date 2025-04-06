import 'package:flutter/material.dart';

// to pass in argument eg:
// () => ButtonFuncs.startBtn(context)

class ButtonFuncs {
  // PAGE NAVIGATION:

  static void startBtn(BuildContext context) {
    Navigator.pushNamed(context, '/inputs');
  }

  static void nextBtnInputs(BuildContext context) {
    Navigator.pushNamed(context, '/selection');
  }

  static void nextBtnResults(BuildContext context) {
    Navigator.pushNamed(context, '/pcb');
  }

  // MATCHING NETWORK TYPES:

  static void autoMatchingBtn(BuildContext context) {
    // placeholder for auto matching logic
    Navigator.pushNamed(context, '/results');
  }

  static void quarterWaveBtn(BuildContext context) {
    // placeholder for QWT button logic
    Navigator.pushNamed(context, '/results');
  }

  static void lumpedElementBtn(BuildContext context) {
    // placeholder for lumped element button logic
    Navigator.pushNamed(context, '/results');
  }

  static void singleStubBtn(BuildContext context) {
    // placeholder for single stub button logic
    Navigator.pushNamed(context, '/results');
  }
}
