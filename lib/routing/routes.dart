import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnifinder/bloc/brain_bloc.dart';
import 'package:omnifinder/providers/bloc_provider.dart';
import 'package:omnifinder/routing/route_arguments/camera_screen_route_arguments.dart';
import 'package:omnifinder/routing/route_parameters.dart';
import 'package:omnifinder/screens/camera_screen.dart';
import 'package:omnifinder/screens/home_screen.dart';

class Routes {
  static const String CAMERA = "camera";
  static const String SPLASH_SCREEN = "splash_screen";
  static const String HOME = "home";

  static Route onGenerateRoute(RouteSettings settings) {
    RouteParameters params = settings.arguments;
    switch (settings.name) {
      case HOME:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => HomeScreen(),
        );
      case CAMERA:
        CameraScreenRouteArguments arguments = params.routeArguments;
        BrainBloc _bloc = BrainBloc(arguments.keywordsContainer);

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider<BrainBloc>(
            child: CameraScreen(),
            bloc: _bloc,
          ),
        );
      default:
        return null;
    }
  }
}
