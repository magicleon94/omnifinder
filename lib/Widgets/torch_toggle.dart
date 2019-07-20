import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TorchToggle extends StatelessWidget {
  final CameraController cameraController;

  final ValueNotifier<bool> _torchNotifier = ValueNotifier<bool>(false);

  TorchToggle({Key key, this.cameraController}) : super(key: key);

  void _toggleTorch() async {
    await cameraController
        .setFlashMode(_torchNotifier.value ? FlashMode.off : FlashMode.torch);
    _torchNotifier.value = cameraController.flashMode == FlashMode.torch;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cameraController.isFlashSupported(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          final bool hasTorch = snapshot.data;

          if (hasTorch) {
            return ValueListenableBuilder(
                valueListenable: _torchNotifier,
                builder: (BuildContext context, bool isTorchOn, _) {
                  return IconButton(
                    icon: Icon(isTorchOn ? Icons.flash_off : Icons.flash_on),
                    onPressed: _toggleTorch,
                  );
                });
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
