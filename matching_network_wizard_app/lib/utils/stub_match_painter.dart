// Custom painter for Stub Matching Network diagram
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

// Custom painter for Single Stub Matching Network diagram
class SingleStubPainter extends CustomPainter {
  final double mainLineWidth;
  final double stubLength;
  final double distanceToStub;
  final double substrateHeight;

  SingleStubPainter({
    required this.mainLineWidth,
    required this.stubLength,
    required this.distanceToStub,
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

    // Draw main transmission line
    final mainLine = Rect.fromLTWH(
        20 * horizontalScale,
        (60 - mainLineWidth * 2) * verticalScale,
        260 * horizontalScale,
        mainLineWidth * 2 * verticalScale);
    canvas.drawRect(mainLine, copperPaint);

    // Calculate stub position (adjust based on distance proportion)
    final stubPositionX = (160 + distanceToStub * 0.5) * horizontalScale;

    // Draw stub
    final stub = Rect.fromLTWH(
        stubPositionX - (mainLineWidth * 0.5) * horizontalScale,
        (60 - mainLineWidth * 2 - stubLength) * verticalScale,
        mainLineWidth * horizontalScale,
        stubLength * verticalScale);
    canvas.drawRect(stub, copperPaint);

    // Draw dimension lines and labels for mainline width
    canvas.drawLine(
        Offset(50 * horizontalScale, (60 - mainLineWidth * 2) * verticalScale),
        Offset(50 * horizontalScale, (50 - mainLineWidth * 2) * verticalScale),
        linePaint);

    canvas.drawLine(Offset(50 * horizontalScale, 60 * verticalScale),
        Offset(50 * horizontalScale, 50 * verticalScale), linePaint);

    canvas.drawLine(
        Offset(45 * horizontalScale, (50 - mainLineWidth * 2) * verticalScale),
        Offset(55 * horizontalScale, (50 - mainLineWidth * 2) * verticalScale),
        linePaint);

    canvas.drawLine(Offset(45 * horizontalScale, 50 * verticalScale),
        Offset(55 * horizontalScale, 50 * verticalScale), linePaint);

    _drawText(
        canvas,
        textPainter,
        textStyle,
        'w = ${mainLineWidth.toStringAsExponential(2)} mm',
        Offset(60 * horizontalScale, (55 - mainLineWidth) * verticalScale));

    // Draw dimension lines for stub length
    canvas.drawLine(
        Offset(stubPositionX + 10 * horizontalScale,
            (60 - mainLineWidth * 2 - stubLength) * verticalScale),
        Offset(stubPositionX + 20 * horizontalScale,
            (60 - mainLineWidth * 2 - stubLength) * verticalScale),
        linePaint);

    canvas.drawLine(
        Offset(stubPositionX + 10 * horizontalScale,
            (60 - mainLineWidth * 2) * verticalScale),
        Offset(stubPositionX + 20 * horizontalScale,
            (60 - mainLineWidth * 2) * verticalScale),
        linePaint);

    canvas.drawLine(
        Offset(stubPositionX + 15 * horizontalScale,
            (60 - mainLineWidth * 2 - stubLength) * verticalScale),
        Offset(stubPositionX + 15 * horizontalScale,
            (60 - mainLineWidth * 2) * verticalScale),
        linePaint);

    _drawText(
        canvas,
        textPainter,
        textStyle,
        'Stub = ${stubLength.toStringAsExponential(2)} mm',
        Offset(stubPositionX + 20 * horizontalScale,
            (60 - mainLineWidth * 2 - stubLength * 0.5) * verticalScale));

    // Draw dimension for distance to stub
    canvas.drawLine(Offset(160 * horizontalScale, 100 * verticalScale),
        Offset(stubPositionX, 100 * verticalScale), linePaint);

    canvas.drawLine(Offset(160 * horizontalScale, 95 * verticalScale),
        Offset(160 * horizontalScale, 105 * verticalScale), linePaint);

    canvas.drawLine(Offset(stubPositionX, 95 * verticalScale),
        Offset(stubPositionX, 105 * verticalScale), linePaint);

    _drawText(
        canvas,
        textPainter,
        textStyle,
        'd = ${distanceToStub.toStringAsExponential(2)} mm',
        Offset(
            (160 + (stubPositionX - 160 * horizontalScale) * 0.5) *
                horizontalScale,
            115 * verticalScale));

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
    _drawText(
        canvas,
        textPainter,
        textStyle,
        'Single Stub Matching Network (Open)',
        Offset(70 * horizontalScale, 15 * verticalScale),
        bold: true);

    _drawText(canvas, textPainter, textStyle, 'Source',
        Offset(30 * horizontalScale, 40 * verticalScale));

    _drawText(canvas, textPainter, textStyle, 'Load',
        Offset(250 * horizontalScale, 40 * verticalScale));

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
