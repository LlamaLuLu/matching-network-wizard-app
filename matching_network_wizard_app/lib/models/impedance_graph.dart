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
}
