import 'package:omnifinder/bloc/bloc_base.dart';
import 'package:omnifinder/routing/route_arguments/route_arguments.dart';

class RouteParameters {
  final BlocBase bloc;
  final RouteArguments routeArguments;

  RouteParameters({
    this.bloc,
    this.routeArguments,
  });

  RouteParameters copyWith(BlocBase newBloc, RouteArguments newRouteArguments) {
    return RouteParameters(
        bloc: newBloc ?? this.bloc,
        routeArguments: newRouteArguments ?? this.routeArguments);
  }
}
