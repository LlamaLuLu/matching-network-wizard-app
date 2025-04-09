import 'dart:math';
import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/calculations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  //---------------------- VARIABLES ----------------------//
  /*
    USER INPUTS:
  */

  // load impedance
  static const String zLReKey = 'zLRe';
  static const String zLImKey = 'zLIm';

  // characteristic impedance of system
  static const String z0Key = 'z0';

  // frequency
  static const String fKey = 'f';

  // matching network type
  static const String matchingNetworkTypeKey = 'matchingNetworkType';
  static const String autoModeKey = 'autoMode';
  static const String matchedKey = 'matched';

  // pcb
  static const String widthKey = 'width';
  static const String heightKey = 'height';
  static const String epsilonRKey = 'epsilonR';

  /*
    CALCULATED RESULTS:
  */

  // QUARTER WAVE TRANSFORMER:

  // characteristic impedance of quarter wave transformer
  static const String zQWTKey = 'zQWTRe';

  // LUMPED ELEMENT MATCHING NETWORK:

  // A: inside solution (RL > Z0)
  static const String xA1 = 'xA1';
  static const String xA2 = 'xA2';
  static const String bA1 = 'bA1';
  static const String bA2 = 'bA2';
  static const String ciA1 = 'ciA1';
  static const String ciA2 = 'ciA2';
  static const String icA1 = 'icA1';
  static const String icA2 = 'icA2';

  // B: outside solution (RL < Z0)
  static const String xB1 = 'xB1';
  static const String xB2 = 'xB2';
  static const String bB1 = 'bB1';
  static const String bB2 = 'bB2';
  static const String ciB1 = 'ciB1';
  static const String ciB2 = 'ciB2';
  static const String icB1 = 'icB1';
  static const String icB2 = 'icB2';

  // SINGLE STUB MATCHING NETWORK:
  static const String t1 = 't1';
  static const String t2 = 't2';
  static const String dDivLambda1 = 'dDivLambda1';
  static const String dDivLambda2 = 'dDivLambda2';
  static const String b1 = 'b1';
  static const String b2 = 'b2';
  static const String lOpenDivLambda1 = 'lOpen1';
  static const String lOpenDivLambda2 = 'lOpen2';
  static const String lShortDivLambda1 = 'lShort1';
  static const String lShortDivLambda2 = 'lShort2';

  //---------------------- FUNCTIONS ----------------------//

  /*
    CLEAR:
  */

  static Future<void> clearSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(zLReKey);
    await prefs.remove(zLImKey);
    await prefs.remove(z0Key);
    await prefs.remove(fKey);
    await prefs.remove(widthKey);
    await prefs.remove(heightKey);
    await prefs.remove(epsilonRKey);
    await prefs.remove(matchingNetworkTypeKey);
    await prefs.remove(autoModeKey);
    await prefs.remove(matchedKey);

    debugPrint('Cleared all saved data');

    // QUARTER WAVE TRANSFORMER:
    await prefs.remove(zQWTKey);

    // LUMPED ELEMENT MATCHING NETWORK:
    await prefs.remove(xA1);
    await prefs.remove(xA2);
    await prefs.remove(bA1);
    await prefs.remove(bA2);
    await prefs.remove(xB1);
    await prefs.remove(xB2);
    await prefs.remove(bB1);
    await prefs.remove(bB2);

    // SINGLE STUB MATCHING NETWORK:
    await prefs.remove(t1);
    await prefs.remove(t2);
    await prefs.remove(dDivLambda1);
    await prefs.remove(dDivLambda2);
    await prefs.remove(b1);
    await prefs.remove(b2);
    await prefs.remove(lOpenDivLambda1);
    await prefs.remove(lOpenDivLambda2);
  }

  /*
    SAVE PAGE DATA:
  */

  static Future<void> saveInputData(
      double z0, double zLRe, double zLIm, double f) async {
    Complex zL = Complex(zLRe, zLIm);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await setZ0(z0);
    await setZL(zL);
    await setF(f);
  }

  static Future<void> saveLumpedData(List<double> xA, List<double> bA,
      List<double> xB, List<double> bB) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await setXA(xA);
    await setBA(bA);
    await setXB(xB);
    await setBB(bB);
  }

  static Future<void> savePCBInputsData(
      double w, double h, double epsilonR) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await setWidth(w);
    await setHeight(h);
    await setEpsilonR(epsilonR);
  }

  static Future<void> checkIfMatched() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final z0 = await getZ0();
    final zL = await getZL();
    final zLNorm = Calculations.normalize(z0, zL);
    if (zLNorm.real == 1 && zLNorm.imaginary == 0) {
      await setMatched(true);
    } else {
      await setMatched(false);
    }
  }

  /*
    SETTERS & GETTERS:
  */

  // FOR PCB:
  // width
  static Future<void> setWidth(double width) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(widthKey, width);
  }

  static Future<double> getWidth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(widthKey) ?? 0.0; // Default value if not set
  }

  // height
  static Future<void> setHeight(double height) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(heightKey, height);
  }

  static Future<double> getHeight() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(heightKey) ?? 0.0; // Default value if not set
  }

  // epsilonR
  static Future<void> setEpsilonR(double epsilonR) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(epsilonRKey, epsilonR);
  }

  static Future<double> getEpsilonR() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(epsilonRKey) ?? 0.0; // Default value if not set
  }

  // cap & ind values
  static Future<void> saveCapIndValues(List<double> capIndList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(ciA1, capIndList[0]);
    await prefs.setDouble(icA1, capIndList[1]);
    await prefs.setDouble(ciA2, capIndList[2]);
    await prefs.setDouble(icA2, capIndList[3]);
    await prefs.setDouble(ciB1, capIndList[4]);
    await prefs.setDouble(icB1, capIndList[5]);
    await prefs.setDouble(ciB2, capIndList[6]);
    await prefs.setDouble(icB2, capIndList[7]);
  }

  static Future<List<double>> getCapIndValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<double> capIndList = [];
    capIndList.addAll(await getCIA());
    capIndList.addAll(await getICA());
    capIndList.addAll(await getCIB());
    capIndList.addAll(await getICB());
    return capIndList;
  }

  // zL
  static Future<void> setZL(Complex zL) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(zLReKey, zL.real);
    await prefs.setDouble(zLImKey, zL.imaginary);
  }

  static Future<Complex> getZL() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double zLRe =
        prefs.getDouble(zLReKey) ?? 0.0; // Default value if not set
    final double zLIm =
        prefs.getDouble(zLImKey) ?? 0.0; // Default value if not set
    return Complex(zLRe, zLIm);
  }

  // z0
  static Future<void> setZ0(double z0) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(z0Key, z0);
  }

  static Future<double> getZ0() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(z0Key) ?? 50.0; // Default value if not set
  }

  // f
  static Future<void> setF(double f) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(fKey, f);
  }

  static Future<double> getF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(fKey) ?? 0.0; // Default value if not set
  }

  // matching network type
  static Future<void> setMatchingNetworkType(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(matchingNetworkTypeKey, type);
  }

  static Future<String> getMatchingNetworkType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(matchingNetworkTypeKey) ??
        ''; // Default value if not set
  }

  // auto mode
  static Future<void> setAutoMode(bool autoMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoModeKey, autoMode);
  }

  static Future<bool> getAutoMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(autoModeKey) ?? false; // Default value if not set
  }

  // matched
  static Future<void> setMatched(bool matched) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(matchedKey, matched);
  }

  static Future<bool> getMatched() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(matchedKey) ?? false; // Default value if not set
  }

  // zQWT
  static Future<void> setZQWT(double zQWT) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(zQWTKey, zQWT);
  }

  static Future<double> getZQWT() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(zQWTKey) ?? 0.0; // Default value if not set
  }

  // xA
  static Future<void> setXA(List<double> xA) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(xA1, xA[0]);
    await prefs.setDouble(xA2, xA[1]);
  }

  static Future<List<double>> getXA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(xA1) ?? 0.0,
      prefs.getDouble(xA2) ?? 0.0
    ]; // Default value if not set
  }

  // bA
  static Future<void> setBA(List<double> bA) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(bA1, bA[0]);
    await prefs.setDouble(bA2, bA[1]);
  }

  static Future<List<double>> getBA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(bA1) ?? 0.0,
      prefs.getDouble(bA2) ?? 0.0
    ]; // Default value if not set
  }

  // cA
  static Future<void> setCIA(List<double> cA) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(ciA1, cA[0]);
    await prefs.setDouble(ciA2, cA[1]);
  }

  static Future<List<double>> getCIA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(ciA1) ?? 0.0,
      prefs.getDouble(ciA2) ?? 0.0
    ]; // Default value if not set
  }

  // iA
  static Future<void> setICA(List<double> iA) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(icA1, iA[0]);
    await prefs.setDouble(icA2, iA[1]);
  }

  static Future<List<double>> getICA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(icA1) ?? 0.0,
      prefs.getDouble(icA2) ?? 0.0
    ]; // Default value if not set
  }

  // xB
  static Future<void> setXB(List<double> xB) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(xB1, xB[0]);
    await prefs.setDouble(xB2, xB[1]);
  }

  static Future<List<double>> getXB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(xB1) ?? 0.0,
      prefs.getDouble(xB2) ?? 0.0
    ]; // Default value if not set
  }

  // bB
  static Future<void> setBB(List<double> bB) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(bB1, bB[0]);
    await prefs.setDouble(bB2, bB[1]);
  }

  static Future<List<double>> getBB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(bB1) ?? 0.0,
      prefs.getDouble(bB2) ?? 0.0
    ]; // Default value if not set
  }

  // cB
  static Future<void> setCIB(List<double> cB) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(ciB1, cB[0]);
    await prefs.setDouble(ciB2, cB[1]);
  }

  static Future<List<double>> getCIB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(ciB1) ?? 0.0,
      prefs.getDouble(ciB2) ?? 0.0
    ]; // Default value if not set
  }

  // iB
  static Future<void> setICB(List<double> iB) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(icB1, iB[0]);
    await prefs.setDouble(icB2, iB[1]);
  }

  static Future<List<double>> getICB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(icB1) ?? 0.0,
      prefs.getDouble(icB2) ?? 0.0
    ]; // Default value if not set
  }

  // t
  static Future<void> setT(List<double> t) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(t1, t[0]);
    await prefs.setDouble(t2, t[1]);
  }

  static Future<List<double>> getT() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(t1) ?? 0.0,
      prefs.getDouble(t2) ?? 0.0
    ]; // Default value if not set
  }

  // dDivLambda
  static Future<void> setDDivLambda(List<double> dDivLambda) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(dDivLambda1, dDivLambda[0]);
    await prefs.setDouble(dDivLambda2, dDivLambda[1]);
  }

  static Future<List<double>> getDDivLambda() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(dDivLambda1) ?? 0.0,
      prefs.getDouble(dDivLambda2) ?? 0.0
    ]; // Default value if not set
  }

  // b
  static Future<void> setB(List<double> b) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(b1, b[0]);
    await prefs.setDouble(b2, b[1]);
  }

  static Future<List<double>> getB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(b1) ?? 0.0,
      prefs.getDouble(b2) ?? 0.0
    ]; // Default value if not set
  }

  // lOpenDivLambda
  static Future<void> setLOpenDivLambda(List<double> lOpenDivLambda) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(lOpenDivLambda1, lOpenDivLambda[0]);
    await prefs.setDouble(lOpenDivLambda2, lOpenDivLambda[1]);
  }

  static Future<List<double>> getLOpenDivLambda() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(lOpenDivLambda1) ?? 0.0,
      prefs.getDouble(lOpenDivLambda2) ?? 0.0
    ]; // Default value if not set
  }

  // lShortDivLambda
  static Future<void> setLShortDivLambda(List<double> lShortDivLambda) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(lShortDivLambda1, lShortDivLambda[0]);
    await prefs.setDouble(lShortDivLambda2, lShortDivLambda[1]);
  }

  static Future<List<double>> getLShortDivLambda() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getDouble(lShortDivLambda1) ?? 0.0,
      prefs.getDouble(lShortDivLambda2) ?? 0.0
    ]; // Default value if not set
  }
}
