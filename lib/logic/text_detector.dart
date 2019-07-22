import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:omnifinder/Logic/camera_to_firevision_bridge.dart';

class TextDetector with CameraToFireVisionBridge {
  final List<String> keywords;

  TextDetector({this.keywords});

  Future<List<TextContainer>> findWords(
      FirebaseVisionImage firebaseVisionImage) async {
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);

    final String pattern = keywords.join("|");

    final RegExp regExp = RegExp(pattern, caseSensitive: false);

    List<TextContainer> matches = const [];

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          if (regExp.hasMatch(element.text)) {
            matches.add(element);
          }
        }
      }
    }

    return matches;
  }
}
