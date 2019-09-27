import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:omnifinder/logic/camera_to_firevision_bridge.dart';

class TextDetector with CameraToFireVisionBridge {
  final List<String> keywords;
  final RegExp regExp;

  TextDetector({this.keywords})
      : regExp = RegExp(keywords.join("|"), caseSensitive: false);

  Future<List<TextContainer>> findWords(
      FirebaseVisionImage firebaseVisionImage) async {
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);

    List<TextContainer> matches = List<TextContainer>();

    for (int i = 0; i < visionText.blocks.length; i++) {
      for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
        for (int k = 0;
            k < visionText.blocks[i].lines[j].elements.length;
            k++) {
          if (regExp.hasMatch(visionText.blocks[i].lines[j].elements[k].text)) {
            matches.add(visionText.blocks[i].lines[j].elements[k]);
          }
        }
      }
    }

    return matches;
  }
}
