import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';

class HolePainter extends CustomPainter {
  HolePainter({
    required this.color,
    required this.holeSize,
  });

  final Color color;
  final double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = holeSize / 2;
    Rect innerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius / 2);

    Path halfTransparentRing = Path()
      ..addOval(innerCircleRect)
      ..close();
    canvas.drawPath(
        halfTransparentRing, Paint()..color = ColorUtils.primaryColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
