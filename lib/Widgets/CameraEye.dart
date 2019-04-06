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

class _CameraEyeState extends State<CameraEye> with CameraToFireVisionBridge {
  CameraController _controller;
  List<CameraDescription> _cameras;
  ImageRotation _imageRotation;
  TextDetector _detector;
  bool _isDetecting = false;

  StreamController<List<TextContainer>> _matchedResultsStream =
      StreamController<List<TextContainer>>.broadcast();

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _imageRotation = rotationIntToImageRotation(_cameras[0].sensorOrientation);
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);

    await _controller.initialize();
    _controller.startImageStream(_listenImage);
  }

  @override
  void initState() {
    _detector = TextDetector(keywords: widget.keywords);
    super.initState();
  }

  void _listenImage(CameraImage image) async {
    final FirebaseVisionImage firebaseVisionImage =
        fromCameraImage(image, _imageRotation);


    if (!_isDetecting) {
      _isDetecting = true;
      List<TextContainer> matchesFound =
          await _detector.findWords(firebaseVisionImage);

      _matchedResultsStream.sink.add(matchesFound);

      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _matchedResultsStream?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initCamera(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!_controller.value.isInitialized) {
            return Container();
          }

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CameraPreview(_controller),
              StreamBuilder(
                stream: _matchedResultsStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomPaint(
                      painter: ResultHighlightPainter(
                        Size(_controller.value.previewSize.width,
                            _controller.value.previewSize.height),
                        snapshot.data,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        } else {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Initialising eye..")
              ],
            ),
          );
        }
      },
    );
  }
}
