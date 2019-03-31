import 'package:flutter/material.dart';
import 'package:omnifinder/CameraEye.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(child: CameraEye()),
          Center(child: FlutterLogo()),
        ],
      ),
    );
  }
}
