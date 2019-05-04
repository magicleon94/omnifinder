import 'package:flutter/material.dart';
import 'package:torch/torch.dart';

class TorchToggle extends StatefulWidget {
  @override
  _TorchToggleState createState() => _TorchToggleState();
}

class _TorchToggleState extends State<TorchToggle> {
  bool _isTorchOn = false;
  bool _hasTorch = false;

  void _toggleTorch() {
    if (_isTorchOn) {
      Torch.turnOff();
    } else {
      Torch.turnOn();
    }

    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _init() async {
    _hasTorch = await Torch.hasTorch;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTorch) {
      return IconButton(
        icon: Icon(_isTorchOn ? Icons.flash_off : Icons.flash_on),
        onPressed: _toggleTorch,
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}
