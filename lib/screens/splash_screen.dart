import 'package:flutter/material.dart';
import 'package:omnifinder/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            Navigator.of(context).pushReplacementNamed(Routes.HOME);
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash!"),
      ),
    );
  }
}
