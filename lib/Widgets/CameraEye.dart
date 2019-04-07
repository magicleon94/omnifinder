import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:omnifinder/Logic/TextDetector.dart';
import 'package:omnifinder/Logic/CameraToFireVisionBridge.dart';
import 'package:omnifinder/Widgets/ResultsHighlightPainter.dart';

class CameraEye extends StatefulWidget {
  final List<String> keywords;

  const CameraEye({Key key, this.keywords}) : super(key: key);

  @override
  _CameraEyeState createState() => _CameraEyeState();
}

class _CameraEyeState extends State<CameraEye>
    with CameraToFireVisionBridge, WidgetsBindingObserver {
  CameraController _controller;
  List<CameraDescription> _cameras;
  List<ResolutionPreset> _resolutionPresets = [
    ResolutionPreset.low,
    ResolutionPreset.medium,
    ResolutionPreset.high
  ];
  int _currentResolutionIndex = 2;

  ImageRotation _imageRotation;
  TextDetector _detector;
  bool _isDetecting = false;
  bool _cameraReady = false;

  List<TextContainer> _searchResults = [];

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _imageRotation = rotationIntToImageRotation(_cameras[0].sensorOrientation);
    _controller = CameraController(
        _cameras[0], _resolutionPresets[_currentResolutionIndex]);

    await _controller.initialize();
    _controller.startImageStream(_listenImage);

    setState(() {
      _cameraReady = _controller.value.isInitialized;
    });
  }

  @override
  void initState() {
    _detector = TextDetector(keywords: widget.keywords);
    _initCamera();
    super.initState();
  }

  @override
  void didChangeMetrics() {
    _initCamera();
    super.didChangeMetrics();
  }

  @override
  void didHaveMemoryPressure() {
    if (_currentResolutionIndex > 0) {
      _currentResolutionIndex--;
      _initCamera();
    }
    super.didHaveMemoryPressure();
  }

  void _listenImage(CameraImage image) async {
    final FirebaseVisionImage firebaseVisionImage =
        fromCameraImage(image, _imageRotation);

    if (!_isDetecting) {
      _isDetecting = true;
      List<TextContainer> matchesFound =
          await _detector.findWords(firebaseVisionImage);

      setState(() {
        _searchResults = matchesFound;
      });

      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraReady) {
      Size imageSize = Size(
        _controller.value.previewSize.height,
        _controller.value.previewSize.width,
      );
      
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller),
          CustomPaint(
            painter: ResultHighlightPainter(
              imageSize,
              _searchResults,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text("Initialising eye..")
        ],
      );
    }
  }
}
