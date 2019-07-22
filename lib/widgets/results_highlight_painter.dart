import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ResultHighlightPainter extends CustomPainter {
  ResultHighlightPainter(this.imageSize, this.matches);

  final Size imageSize;
  final List<TextContainer> matches;

  Rect _scaleRect({
    @required Rect rect,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;

    return Rect.fromLTRB(
      rect.left.toDouble() * scaleX, //bigger!
      rect.top.toDouble() * scaleY, //bigger!
      rect.right.toDouble() * scaleX, //bigger!
      rect.bottom.toDouble() * scaleY, //bigger!
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    paint.color = Colors.red;
    matches.forEach((TextContainer match) {
      Rect scaledRect = _scaleRect(
        rect: match.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
      );
      canvas.drawRect(scaledRect, paint);
    });
  }

  @override
  bool shouldRepaint(ResultHighlightPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.matches != matches;
  }
}
