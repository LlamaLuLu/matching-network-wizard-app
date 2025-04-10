// Custom painter for Quarter-Wave Transformer diagram
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

// Custom painter for Quarter-Wave Transformer diagram
class QuarterWavePainter extends CustomPainter {
  final double transformerWidth;
  final double mainLineWidth;
  final double substrateHeight;

  QuarterWavePainter({
    required this.transformerWidth,
    required this.mainLineWidth,
    required this.substrateHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define colors
    final Color substrateColor = Color(0xFFE0E0E0);
    final Color copperColor = Color(0xFFCD7F32);
    final Color dimensionColor = Colors.black87;

    // Paint objects
    final substratePaint = Paint()
      ..color = substrateColor
      ..style = PaintingStyle.fill;

    final copperPaint = Paint()
      ..color = copperColor
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = dimensionColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: dimensionColor,
      fontSize: 12,
    );
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Scale factors for diagram
    final double horizontalScale = size.width / 300;
    final double verticalScale = size.height / 200;

    // Draw substrate
    final substrateRect = Rect.fromLTWH(20 * horizontalScale,
        60 * verticalScale, 260 * horizontalScale, 30 * verticalScale);
    canvas.drawRect(substrateRect, substratePaint);

    // Draw main line (left)
    final mainLineLeft = Rect.fromLTWH(
        20 * horizontalScale,
        (60 - mainLineWidth * 2) * verticalScale,
        80 * horizontalScale,
        mainLineWidth * 2 * verticalScale);
    canvas.drawRect(mainLineLeft, copperPaint);

    // Draw quarter-wave transformer
    final transformer = Rect.fromLTWH(
        100 * horizontalScale,
        (60 - transformerWidth * 2) * verticalScale,
        100 * horizontalScale,
        transformerWidth * 2 * verticalScale);
    canvas.drawRect(transformer, copperPaint);

    // Draw main line (right)
    final mainLineRight = Rect.fromLTWH(
        200 * horizontalScale,
        (60 - mainLineWidth * 2) * verticalScale,
        80 * horizontalScale,
        mainLineWidth * 2 * verticalScale);
    canvas.drawRect(mainLineRight, copperPaint);

    // Draw dimension lines and labels for transformer width
    canvas.drawLine(
        Offset(
            150 * horizontalScale, (60 - transformerWidth * 2) * verticalScale),
        Offset(
            150 * horizontalScale, (50 - transformerWidth * 2) * verticalScale),
        linePaint);

    canvas.drawLine(Offset(150 * horizontalScale, 60 * verticalScale),
        Offset(150 * horizontalScale, 50 * verticalScale), linePaint);

    canvas.drawLine(
        Offset(
            145 * horizontalScale, (50 - transformerWidth * 2) * verticalScale),
        Offset(
            155 * horizontalScale, (50 - transformerWidth * 2) * verticalScale),
        linePaint);

    canvas.drawLine(Offset(145 * horizontalScale, 50 * verticalScale),
        Offset(155 * horizontalScale, 50 * verticalScale), linePaint);

    canvas.drawLine(
        Offset(
            150 * horizontalScale, (50 - transformerWidth * 2) * verticalScale),
        Offset(150 * horizontalScale, 50 * verticalScale),
        linePaint..strokeWidth = 0.5);

    _drawText(
        canvas,
        textPainter,
        textStyle,
        'w = ${transformerWidth.toStringAsExponential(2)} mm',
        Offset(155 * horizontalScale, (55 - transformerWidth) * verticalScale));

    // Draw dimension lines for transformer length
    canvas.drawLine(Offset(100 * horizontalScale, 40 * verticalScale),
        Offset(200 * horizontalScale, 40 * verticalScale), linePaint);

    canvas.drawLine(Offset(100 * horizontalScale, 35 * verticalScale),
        Offset(100 * horizontalScale, 45 * verticalScale), linePaint);

    canvas.drawLine(Offset(200 * horizontalScale, 35 * verticalScale),
        Offset(200 * horizontalScale, 45 * verticalScale), linePaint);

    _drawText(canvas, textPainter, textStyle, 'λ/4',
        Offset(140 * horizontalScale, 35 * verticalScale));

    // Draw substrate height dimension
    canvas.drawLine(Offset(280 * horizontalScale, 60 * verticalScale),
        Offset(290 * horizontalScale, 60 * verticalScale), linePaint);

    canvas.drawLine(Offset(280 * horizontalScale, 90 * verticalScale),
        Offset(290 * horizontalScale, 90 * verticalScale), linePaint);

    canvas.drawLine(Offset(285 * horizontalScale, 60 * verticalScale),
        Offset(285 * horizontalScale, 90 * verticalScale), linePaint);

    _drawText(
        canvas,
        textPainter,
        textStyle,
        'h = ${substrateHeight.toStringAsExponential(2)} mm',
        Offset(245 * horizontalScale, 100 * verticalScale),
        rotation: -pi / 2);

    // Labels
    _drawText(canvas, textPainter, textStyle, 'Quarter-Wave Transformer',
        Offset(90 * horizontalScale, 15 * verticalScale),
        bold: true);

    _drawText(canvas, textPainter, textStyle, 'Z₀',
        Offset(50 * horizontalScale, (45 - mainLineWidth) * verticalScale));

    _drawText(canvas, textPainter, textStyle, 'Z₁',
        Offset(150 * horizontalScale, (45 - transformerWidth) * verticalScale));

    _drawText(canvas, textPainter, textStyle, 'Z₀',
        Offset(240 * horizontalScale, (45 - mainLineWidth) * verticalScale));

    // Ground plane
    canvas.drawRect(
        Rect.fromLTWH(20 * horizontalScale, 90 * verticalScale,
            260 * horizontalScale, 5 * verticalScale),
        Paint()..color = Colors.grey);
  }

  void _drawText(Canvas canvas, TextPainter textPainter, TextStyle textStyle,
      String text, Offset position,
      {bool bold = false, double rotation = 0}) {
    final ts =
        bold ? textStyle.copyWith(fontWeight: FontWeight.bold) : textStyle;

    textPainter.text = TextSpan(text: text, style: ts);
    textPainter.layout();

    canvas.save();
    if (rotation != 0) {
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      textPainter.paint(canvas, Offset.zero);
    } else {
      textPainter.paint(canvas, position);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
