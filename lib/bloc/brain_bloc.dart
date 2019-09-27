import 'dart:async';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:omnifinder/bloc/bloc_base.dart';
import 'package:omnifinder/logic/text_detector.dart';
import 'package:omnifinder/models/keywords_container.dart';

class BrainBloc extends BlocBase {
  TextDetector _textDetector;

  StreamController<FirebaseVisionImage> _cameraImageStreamController =
      StreamController<FirebaseVisionImage>.broadcast();

  Function(FirebaseVisionImage) get processImage =>
      _cameraImageStreamController.sink.add;

  StreamController<List<TextContainer>> _resultsStream =
      StreamController<List<TextContainer>>();

  Stream<List<TextContainer>> get detectionResultStream =>
      _resultsStream.stream;

  Future<void> _processImage(FirebaseVisionImage image) async {
    List<TextContainer> matchesFound = await _textDetector.findWords(image);
    if (matchesFound.isNotEmpty) {
      _resultsStream.sink.add(matchesFound);
    }
  }

  @override
  void dispose() {
    _cameraImageStreamController?.close();
    _resultsStream?.close();
  }

  BrainBloc(KeywordsContainer keywordsContainer) {
    _textDetector = TextDetector(keywords: keywordsContainer.keywords);
    _cameraImageStreamController.stream.listen(_processImage);
  }
}
