import 'dart:math';
import 'package:complex/complex.dart';
import 'package:flutter/material.dart';

class Calculations {
  //----------------------- QUARTER WAVE TRANSFORMER ----------------------//
  static double calcZQWT(double z0, double zLRe) {
    double zQWT = sqrt(z0 * zLRe);

    return zQWT;
  }

  //------------------ LUMPED ELEMENT MATCHING NETWORK --------------------//
  static List<double> calcLumpedInside(double z0, double zLRe, double zLIm) {
    List<double> bSeries = calcBIn(z0, zLRe, zLIm);
    List<double> xSeries = calcXIn(bSeries, z0, zLRe, zLIm);
    debugPrint([xSeries[0], xSeries[1], bSeries[0], bSeries[1]].toString());

    return [xSeries[0], xSeries[1], bSeries[0], bSeries[1]];
  }

  static List<double> calcLumpedOutside(double z0, double zLRe, double zLIm) {
    List<double> bShunt = calcBOut(z0, zLRe);
    List<double> xShunt = calcXOut(z0, zLRe, zLIm);
    debugPrint([xShunt[0], xShunt[1], bShunt[0], bShunt[1]].toString());

    return [xShunt[0], xShunt[1], bShunt[0], bShunt[1]];
  }

  static List<double> calcXIn(
      List<double> bSeries, double z0, double zLRe, double zLIm) {
    if (zLRe == 0) {
      throw ArgumentError('zLRe cannot be zero to avoid division by zero.');
    }

    final List<double> xSeries = [];
    for (final b in bSeries) {
      final term1 = 1 / b;
      final term2 = (zLIm * z0) / zLRe;
      final term3 = z0 / (b * zLRe);
      final x = term1 + term2 - term3;
      xSeries.add(x);
    }
    return xSeries;
  }

  static List<double> calcBIn(double z0, double zLRe, double zLIm) {
    final term1 = sqrt(zLRe / z0);
    final term2 = sqrt(pow(zLRe, 2) + pow(zLIm, 2) - z0 * zLRe);
    final term3 = pow(zLRe, 2) + pow(zLIm, 2);

    final bA1 = (zLIm + term1 * term2) / term3;
    final bA2 = (zLIm - term1 * term2) / term3;

    return [bA1, bA2];
  }

  static List<double> calcXOut(double z0, double zLRe, double zLIm) {
    final term1 = sqrt(zLRe * (z0 - zLRe));

    final xB1 = term1 - zLIm;
    final xB2 = -term1 - zLIm;

    return [xB1, xB2];
  }

  static List<double> calcBOut(double z0, double zLRe) {
    final term1 = sqrt((z0 - zLRe) / zLRe);

    double bB1 = term1 / z0;
    double bB2 = -term1 / z0;

    return [bB1, bB2];
  }

  //------------------- SINGLE STUB MATCHING NETWORK ----------------------//
  static List<double> calcT(double z0, double zLRe, double zLIm) {
    if (zLRe == z0) {
      final t = -zLIm / (2 * z0);

      return [t];
    } else {
      final term1 = sqrt((zLRe * (pow((z0 - zLRe), 2))) + pow(zLIm, 2));
      final term2 = zLRe - z0;

      final t1 = (zLIm + term1) / term2;
      final t2 = (zLIm - term1) / term2;

      return [t1, t2];
    }
  }

  static List<double> calcDDivLambda(List<double> tList) {
    const term1 = 1 / (2 * pi);
    final List<double> dDivLambdaList = [];

    for (final t in tList) {
      double term2;
      if (t >= 0) {
        term2 = atan(t);
      } else {
        term2 = pi + atan(t);
      }
      final dDivLambda = term1 * term2;
      dDivLambdaList.add(dDivLambda);
    }

    return dDivLambdaList;
  }

  static List<double> calcBStub(
      List<double> tList, double z0, double zLRe, double zLIm) {
    final List<double> bList = [];
    for (final t in tList) {
      final term1 = pow(zLRe, 2) * t;
      final term2 = z0 - zLIm * t;
      final term3 = zLIm + z0 * t;
      final term4 = pow(zLRe, 2) + pow(zLIm + z0 * t, 2);
      final b = (term1 - term2 * term3) / (z0 * term4);
      bList.add(b);
    }
    return bList;
  }

  static List<double> calcLOpenDivLambda(List<double> bList, double z0) {
    // Bs = -B
    final y0 = 1 / z0;
    final List<double> lOpenDivLambdaList = [];
    for (final b in bList) {
      final term1 = -1 / (2 * pi);
      final term2 = atan(b / y0);
      final lOpenDivLambda = term1 * term2;
      // if lShortDivLambda is negative, add lambda/2 to it
      lOpenDivLambdaList.add(lOpenDivLambda);
    }
    return lOpenDivLambdaList;
  }

  static List<double> calcLShortDivLambda(List<double> bList, double z0) {
    // Bs = -B
    final y0 = 1 / z0;
    final List<double> lShortDivLambdaList = [];
    for (final b in bList) {
      final term1 = 1 / (2 * pi);
      final term2 = atan(y0 / b);
      final lShortDivLambda = term1 * term2;
      // if lShortDivLambda is negative, add lambda/2 to it
      lShortDivLambdaList.add(lShortDivLambda);
    }
    return lShortDivLambdaList;
  }
}
