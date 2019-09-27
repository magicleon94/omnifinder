import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class HighlightsClipper extends CustomClipper<Path> {
  final Size imageSize;
  final List<TextContainer> matches;

  HighlightsClipper({
    @required this.imageSize,
    this.matches: const [],
  });

  Rect _scaleRect({
    @required Rect rect,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;
    double delta = 10;
    return Rect.fromLTRB(
      rect.left.toDouble() * scaleX - delta, //bigger!
      rect.top.toDouble() * scaleY - delta, //bigger!
      rect.right.toDouble() * scaleX + delta, //bigger!
      rect.bottom.toDouble() * scaleY + delta, //bigger!
    );
  }

  @override
  Path getClip(Size size) {
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int i = 0; i < matches.length; i++) {
      Rect scaledRect = _scaleRect(
        rect: matches[i].boundingBox,
        widgetSize: size,
      );
      path.addRRect(
        RRect.fromRectAndRadius(
          scaledRect,
          Radius.circular(3),
        ),
      );
    }

    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
