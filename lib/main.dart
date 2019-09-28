import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnifinder/light_theme.dart';
import 'package:omnifinder/routing/routes.dart';
import 'package:omnifinder/screens/splash_screen.dart';

Future<void> main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick finder!',
      theme: lightTheme,
      home: SplashScreen(),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
