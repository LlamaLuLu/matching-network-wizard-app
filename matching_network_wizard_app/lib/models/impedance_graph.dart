import 'dart:math';

import 'package:complex/complex.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/impedance_point.dart';

class ImpedanceGraph extends StatelessWidget {
  final List<ImpedancePoint> points;
  final String mode; // 'real', 'imag', 'magnitude'

  const ImpedanceGraph({required this.points, this.mode = 'real', super.key});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = points.map((pt) {
      double y = switch (mode) {
        'real' => pt.real,
        'imag' => pt.imag,
        'magnitude' => pt.magnitude,
        _ => pt.real
      };
      return FlSpot(pt.frequencyMHz, y);
    }).toList();

    return LineChart(
      LineChartData(
        minX: points.first.frequencyMHz,
        maxX: points.last.frequencyMHz,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 50,
              getTitlesWidget: (value, meta) =>
                  Text('${value.toStringAsFixed(0)} MHz'),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  static List<FlSpot> impedancePointsToFlSpots(List<ImpedancePoint> points,
      {String mode = 'magnitude'}) {
    return points.map((point) {
      double y = switch (mode) {
        'real' => point.real,
        'imag' => point.imag,
        'magnitude' => point.magnitude,
        _ => point.real,
      };
      return FlSpot(point.frequencyMHz / 1000.0, y); // Convert MHz to GHz
    }).toList();
  }

  static List<FlSpot> generateLumpedElementImpedanceGraph({
    required double zlReal, // Load resistance
    required double zlImag, // Load reactance
    required double z0, // Characteristic impedance
    required double f0MHz, // Centre frequency in MHz
    required bool seriesFirst, // true = series first, false = shunt first
  }) {
    const int numPoints = 200;
    final double f0Hz = f0MHz * 1e6;
    final double fMin = f0Hz * 0.5;
    final double fMax = f0Hz * 1.5;
    final double step = (fMax - fMin) / (numPoints - 1);

    final List<FlSpot> spots = [];

    // Convert load to complex
    final Complex zLoad = Complex(zlReal, zlImag);

    for (int i = 0; i < numPoints; i++) {
      final double freq = fMin + i * step;
      final double omega = 2 * pi * freq;

      // TODO: Replace these with your matching element values for f0
      // For now, placeholders for illustrative purposes:
      final double c = 1e-12; // Farads
      final double l = 1e-9; // Henries

      Complex zin;

      if (seriesFirst) {
        // Series element: L or C
        Complex zs = Complex(0, omega * l); // Assume inductor
        // Shunt element: L or C
        Complex ys = Complex(0, omega * c); // Assume capacitor (admittance)

        Complex z1 = zLoad + zs;
        Complex yTotal = Complex(1, 0) / z1 + ys;
        zin = Complex(1, 0) / yTotal;
      } else {
        // Shunt element first
        Complex ys = Complex(0, omega * c); // Assume capacitor
        Complex y1 = Complex(1, 0) / zLoad + ys;
        Complex z1 = Complex(1, 0) / y1;

        Complex zs = Complex(0, omega * l); // Assume inductor
        zin = z1 + zs;
      }

      // Plot frequency in MHz vs |Zin| in Ohms
      spots.add(FlSpot(freq / 1e6, zin.abs()));
    }

    return spots;
  }

  /// Generates impedance data for a single stub shunt matching network across a frequency range
  static List<FlSpot> generateSingleStubImpedanceGraph({
    required double zlReal,
    required double zlImag,
    required double z0,
    required double f0MHz,
    required double stubLength, // in wavelengths
    required double distanceToLoad, // in wavelengths
    int points = 200, // number of frequency points to calculate
    double bandwidth =
        0.5, // frequency range as a fraction of f0 (±0.5 means 0.5f0 to 1.5f0)
  }) {
    // Create list to store results
    List<FlSpot> impedanceData = [];

    // Calculate frequency range
    double fMin = f0MHz * (1 - bandwidth);
    double fMax = f0MHz * (1 + bandwidth);
    double fStep = (fMax - fMin) / points;

    // Load impedance at design frequency
    Complex zL = Complex(zlReal, zlImag);

    // For each frequency point
    for (int i = 0; i <= points; i++) {
      double frequency = fMin + (i * fStep);

      // Scale wavelength ratio by frequency
      double frequencyRatio = frequency / f0MHz;
      double scaledDistance = distanceToLoad * frequencyRatio;
      double scaledStubLength = stubLength * frequencyRatio;

      // Calculate impedance at this frequency
      // 1. Transform load impedance to stub junction using transmission line equation
      Complex impedanceAtJunction = transformImpedanceAlongLine(
        zL: zL,
        z0: z0,
        electricalLength:
            scaledDistance * 2 * pi, // convert wavelength to radians
      );

      // 2. Calculate stub input impedance (open or short stub)
      Complex stubImpedance = calculateStubImpedance(
        z0: z0,
        electricalLength:
            scaledStubLength * 2 * pi, // convert wavelength to radians
        isOpenStub: true, // change to false for short stub
      );

      // 3. Combine stub (in parallel) with the impedance at junction
      Complex resultImpedance =
          parallelImpedance(impedanceAtJunction, stubImpedance);

      // 4. Transform this combined impedance to the input
      Complex inputImpedance = transformImpedanceAlongLine(
        zL: resultImpedance,
        z0: z0,
        electricalLength: 0, // We're already at the input (change if needed)
      );

      // Add to results
      impedanceData.add(FlSpot(frequency, inputImpedance.abs()));
    }

    return impedanceData;
  }

// Helper function to transform impedance along a transmission line
  static Complex transformImpedanceAlongLine({
    required Complex zL,
    required double z0,
    required double electricalLength, // in radians
  }) {
    Complex z0Complex = Complex(z0, 0);

    // Transmission line equation:
    // Zin = Z0 * (ZL + j*Z0*tan(βL)) / (Z0 + j*ZL*tan(βL))
    Complex numerator = zL +
        (z0Complex * Complex(0, 1) * Complex.polar(1, tan(electricalLength)));
    Complex denominator = z0Complex +
        (zL * Complex(0, 1) * Complex.polar(1, tan(electricalLength)));

    return z0Complex * (numerator / denominator);
  }

// Helper function to calculate stub impedance
  static Complex calculateStubImpedance({
    required double z0,
    required double electricalLength, // in radians
    required bool isOpenStub,
  }) {
    if (isOpenStub) {
      // Open stub: Zin = -j*Z0/tan(βL)
      return Complex(0, -z0 / tan(electricalLength));
    } else {
      // Shorted stub: Zin = j*Z0*tan(βL)
      return Complex(0, z0 * tan(electricalLength));
    }
  }

// Helper function to combine impedances in parallel
  static Complex parallelImpedance(Complex z1, Complex z2) {
    return (z1 * z2) / (z1 + z2);
  }

// Add this to compute single stub matching parameters based on ZL and Z0
  static Map<String, double> computeSingleStubParameters({
    required Complex zL,
    required double z0,
  }) {
    // Normalized load impedance
    double rN = zL.real / z0;
    double xN = zL.imaginary / z0;

    // Calculate stub distance from load (in wavelengths)
    double y = sqrt((1 - rN) / rN);
    double distanceToLoad = atan(y + xN / rN) / (2 * pi);

    // Ensure positive distance
    if (distanceToLoad < 0) {
      distanceToLoad += 0.5; // Add half-wavelength
    }

    // Calculate stub admittance
    double b = y / rN;

    // Calculate stub length for open stub (in wavelengths)
    double stubLength = atan(1 / b) / (2 * pi);

    // Ensure positive length
    if (stubLength < 0) {
      stubLength += 0.5; // Add half-wavelength
    }

    return {
      'distanceToLoad': distanceToLoad,
      'stubLength': stubLength,
    };
  }
}
