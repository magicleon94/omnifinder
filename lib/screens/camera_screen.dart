import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnifinder/widgets/camera_eye.dart';

class CameraScreen extends StatefulWidget {
  final List<String> keywords;

  CameraScreen({this.keywords});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays([]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CameraEye(keywords: widget.keywords),
    ));
  }
}
