import 'package:flutter/material.dart';
import 'package:omnifinder/Widgets/CameraEye.dart';

class CameraScreen extends StatefulWidget {
  final List<String> keywords;

  CameraScreen({this.keywords});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CameraEye(keywords: widget.keywords),
      )
    );
  }
}
