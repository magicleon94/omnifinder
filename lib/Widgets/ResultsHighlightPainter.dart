import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ResultHighlightPainter extends CustomPainter {
  ResultHighlightPainter(this.absoluteImageSize, this.matches);

  final Size absoluteImageSize;
  final List<TextContainer> matches;

  Rect scaleRect(TextContainer container, double scaleX, double scaleY) {
    return Rect.fromLTRB(
      container.boundingBox.left.toDouble() * scaleX,
      container.boundingBox.top.toDouble() * scaleY,
      container.boundingBox.right.toDouble() * scaleX,
      container.boundingBox.bottom.toDouble() * scaleY,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    paint.color = Colors.green;
    matches.forEach(
        (match) => canvas.drawRect(scaleRect(match, scaleX, scaleY), paint));
  }

  @override
  bool shouldRepaint(ResultHighlightPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.matches != matches;
  }
}
