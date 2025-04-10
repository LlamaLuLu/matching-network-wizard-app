import 'dart:math';
import 'package:complex/complex.dart';
import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_widgets.dart';
import 'package:matching_network_wizard_app/utils/constants.dart';

class Calculations {
  static Complex normalize(double z0, Complex zL) {
    Complex zLNorm = Complex(zL.real / z0, zL.imaginary / z0);
    return zLNorm;
  }

  //----------------------- QUARTER WAVE TRANSFORMER ----------------------//
  static double calcZQWT(double z0, double zLRe) {
    double zQWT = sqrt(z0 * zLRe);

    return zQWT;
  }

  static double lambdaDiv4(double f) {
    double lambda = 1 / f;
    double lambdaDiv4 = lambda / 4;
    return lambdaDiv4;
  }

  //------------------ LUMPED ELEMENT MATCHING NETWORK --------------------//
  static List<double> calcCapIndValues(
      List<double> bList, List<double> xList, double z0, double f) {
    final List<double> capIndValues = [];
    for (int i = 0; i < bList.length; i++) {
      double b = bList[i];
      double x = xList[i];
      double ci, ic;

      String xType = AppWidgets.capOrInd('x', x);
      String bType = AppWidgets.capOrInd('b', b);
      // if X pos -> inductor, if X neg -> capacitor
      // if B pos -> capacitor, if B neg -> inductor

      if ((xType == 'Capacitor') && (bType == 'Capacitor')) {
        ci = calcCapX(x, z0, f);
        ic = calcCapB(b, z0, f);
      } else if ((xType == 'Inductor') && (bType == 'Inductor')) {
        ci = calcIndX(x, z0, f);
        ic = calcIndB(b, z0, f);
      } else if ((xType == 'Capacitor') && (bType == 'Inductor')) {
        ci = calcCapX(x, z0, f);
        ic = calcIndB(b, z0, f);
      } else if ((xType == 'Inductor') && (bType == 'Capacitor')) {
        ci = calcIndX(x, z0, f);
        ic = calcCapB(b, z0, f);
      } else {
        ci = 0;
        ic = 0;
      }

      capIndValues.add(ci);
      capIndValues.add(ic);
    }
    return capIndValues;
  }

  static double calcCapX(double X, double z0, double f) {
    double c, term1, term2;
    double x = X / z0;

    term1 = -1 / (2 * pi * f);
    term2 = 1 / (x * z0);
    c = term1 * term2;

    return c;
  }

  static double calcCapB(double B, double z0, double f) {
    double c, term1, term2;
    double b = B * z0;

    term1 = 1 / (2 * pi * f);
    term2 = b / z0;
    c = term1 * term2;

    return c;
  }

  static double calcIndX(double X, double z0, double f) {
    double l, term1, term2;
    double x = X / z0;

    term1 = 1 / (2 * pi * f);
    term2 = x * z0;
    l = term1 * term2;

    return l;
  }

  static double calcIndB(double B, double z0, double f) {
    double l, term1, term2;
    double b = B * z0;

    term1 = -1 / (2 * pi * f);
    term2 = z0 / b;
    l = term1 * term2;

    return l;
  }

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

      return [t, 0];
    } else {
      final term1 = pow((z0 - zLRe), 2) + pow(zLIm, 2);
      final term2 = sqrt(zLRe * term1 / z0);
      final term3 = zLRe - z0;

      final t1 = (zLIm + term2) / term3;
      final t2 = (zLIm - term2) / term3;

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
    final term1 = -1 / (2 * pi);

    final List<double> lOpenDivLambdaList = [];
    for (final b in bList) {
      final term2 = atan(b / y0);
      double lOpenDivLambda = term1 * term2;
      if (lOpenDivLambda < 0) {
        lOpenDivLambda += 0.5;
      }
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
      double lShortDivLambda = term1 * term2;
      if (lShortDivLambda < 0) {
        lShortDivLambda += 0.5;
      }
      lShortDivLambdaList.add(lShortDivLambda);
    }
    return lShortDivLambdaList;
  }

  //--------------------------- PCB DESIGN --------------------------------//
  // Calculate ε_eff (Effective dielectric constant)
  static double calcEpsilonEff(double w, double h, double er) {
    double whRatio = w / h;
    if (whRatio < 1) {
      return (er + 1) / 2 +
          ((er - 1) / 2) *
              (1 / sqrt(1 + 12 / whRatio) + 0.04 * pow(1 - whRatio, 2));
    } else {
      return (er + 1) / 2 + ((er - 1) / 2) * (1 / sqrt(1 + 12 / whRatio));
    }
  }

  // Guided wavelength λg in mm
  static double calcLambdaG(double epsilonEff, double f) {
    // f should be in GHz
    double fGHz = f;
    if (f > 1e9) {
      fGHz = f / 1e9; // Convert Hz to GHz if needed
    }

    // Add safeguards against division by zero or near-zero
    if (fGHz < 1e-6 || epsilonEff < 1e-6) {
      return 0.0;
    }

    double lambda = Constants.C / (fGHz * 1e9 * sqrt(epsilonEff)); // in meters
    return lambda * 1000; // Convert to mm
  }

// Calculate impedance Z0 in ohms
  static double calcZ0(double w, double h, double er) {
    double whRatio = w / h;
    double eeff = calcEpsilonEff(w, h, er);

    if (whRatio <= 1) {
      return (60 / sqrt(eeff)) * log((8 * h / w) + (0.25 * w / h));
    } else {
      return (120 * pi) /
          (sqrt(eeff) * (whRatio + 1.393 + 0.667 * log(whRatio + 1.444)));
    }
  }

// Estimate width W (in mm) for a given impedance Z0
  static double estimateWidth(double z0, double h, double er) {
    // h in mm, z0 in ohms
    double w = h; // Initial guess
    double step = h / 10;

    for (int i = 0; i < 1000; i++) {
      double calculatedZ0 =
          calcZ0(w / 1000, h / 1000, er); // Convert to meters for calculation

      if ((calculatedZ0 - z0).abs() < 0.1) {
        return w; // Return width in mm
      }

      // Adjust width based on impedance comparison
      if (calculatedZ0 > z0) {
        w += step; // Wider track for lower impedance
      } else {
        w -= step; // Narrower track for higher impedance
      }

      // Reduce step size as we get closer
      if (i % 100 == 0) step /= 2;
    }

    return w; // Return best approximation
  }

  // Calculate quarter-wave transformer
  static Map<String, double> quarterWaveTransformer(
      double z0, double zLoad, double f, double h, double er) {
    // Calculate characteristic impedance of quarter-wave section
    double zT = sqrt(z0 * zLoad);

    // Calculate the width of the quarter-wave section
    double width = estimateWidth(zT, h, er);

    // Calculate effective dielectric constant for this width
    double eeff = calcEpsilonEff(width / 1000, h / 1000, er);

    // Calculate the guided wavelength
    double lambdaG = calcLambdaG(eeff, f);

    // Quarter wavelength
    double length = lambdaG / 4;

    return {
      'impedance': zT,
      'width': width,
      'length': length,
    };
  }

  // Calculate single stub match
  static Map<String, double> singleStubMatch(double z0, double zReal,
      double zImag, double f, double h, double er, bool isOpenStub) {
    // Normalize the load impedance
    Complex zL = Complex(zReal, zImag) / z0;

    // Calculate admittance
    Complex yL = Complex(1, 0) / zL;

    // First, find the distance where the normalized conductance equals 1
    double d = 0;
    double dStep = 1.0; // 1 degree step for searching
    double bestDiff = double.infinity;
    double bestD = 0;

    for (d = 0; d < 360; d += dStep) {
      double beta = d * pi / 180; // Convert to radians

      // Calculate admittance at distance d
      double theta = 2 * beta; // Electrical length in radians
      Complex numerator = zL * Complex.polar(1, theta) + Complex(z0, 0);
      Complex denominator = Complex(z0, 0) * Complex.polar(1, theta) + zL;
      Complex zd = Complex(z0, 0) * (numerator / denominator);
      Complex yd = Complex(1, 0) / (zd / z0);

      // Check how close the conductance (real part) is to 1
      double diff = (yd.real - 1).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestD = d;
      }

      // Accept if we're close enough
      if (diff < 0.01) break;
    }

    // Use the best distance found
    d = bestD;
    double beta = d * pi / 180;

    // Calculate admittance at this distance
    Complex numerator = zL * Complex.polar(1, 2 * beta) + Complex(z0, 0);
    Complex denominator = Complex(z0, 0) * Complex.polar(1, 2 * beta) + zL;
    Complex zd = Complex(z0, 0) * (numerator / denominator);
    Complex yd = Complex(1, 0) / (zd / z0);

    // The stub must cancel the susceptance
    double b = -yd.imaginary;

    // Calculate stub length
    double stubAngle;
    if (isOpenStub) {
      // For open stub: B = tan(βl)
      stubAngle = atan(b) * 180 / pi;
      if (stubAngle < 0) stubAngle += 180; // Ensure positive length
    } else {
      // For shorted stub: B = -cot(βl)
      stubAngle = atan(-1 / b) * 180 / pi;
      if (stubAngle < 0) stubAngle += 180; // Ensure positive length
    }

    // Calculate physical lengths
    double width = estimateWidth(z0, h, er);
    double eeff = calcEpsilonEff(width / 1000, h / 1000, er);
    double lambdaG = calcLambdaG(eeff, f);

    double distanceToStub = (d / 360) * lambdaG;
    double stubLength = (stubAngle / 360) * lambdaG;

    return {
      'distanceToStub': distanceToStub,
      'stubLength': stubLength,
      'mainLineWidth': width,
      'electricalLengthToStub': d,
      'stubElectricalLength': stubAngle,
    };
  }

  // // Main function to calculate both solutions based on user inputs
  // static Map<String, Map<String, double>> calculateMicrostripSolutions(
  //     double z0, double f, double h, double er,
  //     {double zLoad = 75.0, double zImag = 0.0}) {
  //   // Calculate quarter-wave transformer
  //   var qwt = quarterWaveTransformer(z0, zLoad, f, h, er);

  //   // Calculate single stub match (open stub)
  //   var singleStub = singleStubMatch(z0, zLoad, zImag, f, h, er, true);

  //   return {
  //     'quarterWave': qwt,
  //     'singleStub': singleStub,
  //   };
  // }

  // Track length calculation for a given electrical length in degrees
  static double getTrackLength(
      double degrees, double z0, double h, double er, double f) {
    // h in mm, f in GHz, z0 in ohms, returns length in mm
    double w = estimateWidth(z0, h, er); // Width in mm
    double epsilonEff = calcEpsilonEff(w / 1000, h / 1000, er);
    double lambdaG = calcLambdaG(epsilonEff, f);
    double length = (degrees / 360.0) * lambdaG; // Length in mm

    // Ensure we never return -0 or negative values
    return length.abs() < 1e-10 ? 0.0 : length;
  }
}
