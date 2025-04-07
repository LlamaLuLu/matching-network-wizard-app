import 'dart:math';
import 'package:complex/complex.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:matching_network_wizard_app/models/impedance_point.dart';

List<ImpedancePoint> computeQuarterWaveSweep({
  required Complex ZL,
  required double Z0,
  required double f0MHz,
  int steps = 100,
}) {
  // Calculate ideal transformer impedance using correct sqrt method
  final Z1 = Complex(Z0 * ZL.abs(), 0).sqrt();

  final fMin = 0.5 * f0MHz;
  final fMax = 1.5 * f0MHz;
  final df = (fMax - fMin) / steps;

  List<ImpedancePoint> data = [];

  for (int i = 0; i <= steps; i++) {
    final fMHz = fMin + i * df;
    final theta = pi / 2 * (fMHz / f0MHz); // Normalised frequency sweep

    final tanTheta = tan(theta);

    // Zin = Z1 * (ZL + jZ1*tanθ) / (Z1 + jZL*tanθ)
    final numerator = ZL + Complex(0, Z1.real * tanTheta);
    final denominator = Complex(Z1.real, 0) + Complex(0, ZL.real * tanTheta);
    final Zin = Z1 * (numerator / denominator);

    data.add(ImpedancePoint(fMHz, Zin.real, Zin.imaginary));
  }

  return data;
}
