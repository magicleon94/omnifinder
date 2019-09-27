import 'package:flutter/material.dart';

class FadeInRoute extends PageRouteBuilder {
  final Widget child;

  FadeInRoute({@required this.child})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return child;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            Animation<double> fadeAnimation =
                Tween<double>(begin: 0, end: 1).animate(animation);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          opaque: false,
        );
}
