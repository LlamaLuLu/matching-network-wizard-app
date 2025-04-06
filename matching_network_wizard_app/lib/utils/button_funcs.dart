import 'package:flutter/material.dart';

// to pass in argument eg:
// () => ButtonFuncs.startBtn(context)

class ButtonFuncs {
  static void startBtn(BuildContext context) {
    Navigator.pushNamed(context, '/inputs');
  }

  static void nextBtnInputs(BuildContext context) {
    Navigator.pushNamed(context, '/selection');
  }

  static void nextBtnSelection(BuildContext context) {
    Navigator.pushNamed(context, '/results');
  }

  static void nextBtnResults(BuildContext context) {
    Navigator.pushNamed(context, '/pcb');
  }
}
