import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnifinder/bloc/brain_bloc.dart';
import 'package:omnifinder/providers/bloc_provider.dart';
import 'package:omnifinder/routing/fade_route_builder.dart';
import 'package:omnifinder/routing/route_arguments/camera_screen_route_arguments.dart';
import 'package:omnifinder/routing/route_arguments/keyword_input_route_arguments.dart';
import 'package:omnifinder/routing/route_parameters.dart';
import 'package:omnifinder/screens/camera_screen.dart';
import 'package:omnifinder/screens/home_screen.dart';
import 'package:omnifinder/screens/keyword_input_screen.dart';

class Routes {
  static const String CAMERA = "camera";
  static const String SPLASH_SCREEN = "splash_screen";
  static const String HOME = "home";
  static const String KEYWORD_INPUT = "keyword_input";

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

      case KEYWORD_INPUT:
        KeywordInputRouteArguments arguments = params.routeArguments;
        return FadeInRoute(
          child: KeywordInputScreen(
            initialValue: arguments.initialValue,
          ),
        );
      default:
        return null;
    }
  }
}
