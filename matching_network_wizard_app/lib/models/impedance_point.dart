import 'dart:math';

class ImpedancePoint {
  final double frequencyMHz;
  final double real;
  final double imag;

  ImpedancePoint(this.frequencyMHz, this.real, this.imag);

  double get magnitude => sqrt(real * real + imag * imag);
}
