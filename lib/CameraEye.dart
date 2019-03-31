import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraEye extends StatefulWidget {
  @override
  _CameraEyeState createState() => _CameraEyeState();
}

class _CameraEyeState extends State<CameraEye> {
  CameraController _controller;
  List<CameraDescription> _cameras;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);

    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
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
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}
