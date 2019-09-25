import 'dart:async';

import 'package:camera/camera.dart';
import 'package:omnifinder/bloc/bloc_base.dart';

class BrainBloc extends BlocBase {
  StreamController<CameraImage> _cameraImageStreamController =
      StreamController<CameraImage>.broadcast();

  Function(CameraImage) get processImage =>
      _cameraImageStreamController.sink.add;

  @override
  void dispose() {
    _cameraImageStreamController?.close();
  }
}
