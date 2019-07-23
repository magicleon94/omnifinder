import 'dart:async';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:omnifinder/logic/camera_to_firevision_bridge.dart';
import 'package:omnifinder/logic/text_detector.dart';
import 'package:omnifinder/widgets/results_highlight_painter.dart';
import 'package:synchronized/synchronized.dart';

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

  Lock _lock = Lock();

  StreamController<List<TextContainer>> _resultsStream =
      StreamController<List<TextContainer>>.broadcast();

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

  void _listenImage(CameraImage image) async {
    bool shallDie = await _lock.synchronized<bool>(
      () {
        if (_isDetecting) {
          return true;
        } else {
          _isDetecting = true;
          return false;
        }
      },
    );

    if (shallDie) {
      return;
    } else {
      Isolate.spawn<CameraImage>(_processImage, image);
      return;
    }
  }

  void _processImage(CameraImage image) async {
    final FirebaseVisionImage firebaseVisionImage =
        fromCameraImage(image, _imageRotation);
    List<TextContainer> matchesFound =
        await _detector.findWords(firebaseVisionImage);

    if (!_resultsStream.isClosed && matchesFound.length > 0) {
      _resultsStream.sink.add(matchesFound);
    }

    _lock.synchronized(
      () {
        _isDetecting = false;
      },
    );
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

  @override
  void dispose() {
    _resultsStream?.close();
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
          StreamBuilder(
            stream: _resultsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TextContainer> searchResults = snapshot.data;
                return CustomPaint(
                  painter: ResultHighlightPainter(
                    imageSize,
                    searchResults,
                  ),
                );
              }
              return Container();
            },
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
