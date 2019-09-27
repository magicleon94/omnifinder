/*
  This Inherited Widget provides the designed BLoC to everyone below it in the widget tree.
*/

import 'package:flutter/widgets.dart';
import 'package:omnifinder/bloc/bloc_base.dart';

Type _typeOf<T>() => T;

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T bloc;
  final bool dispose;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.dispose: true,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    if (widget.dispose) {
      widget.bloc?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
