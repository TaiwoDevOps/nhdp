import 'package:africhange/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhbp/core/providers.dart';

final navigator = Nav();

class Nav {
  final key = GlobalKey<NavigatorState>();
  NavigatorState? get state => key.currentState;
  BuildContext? get context => key.currentState?.context;

  Future<dynamic>? pushTop(String routeName) {
    return state!.pushNamed(routeName);
  }

  Future<dynamic> replaceTop(
    Widget page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route = _materialRoute(
      page,
      isDialog: isDialog,
      isTransparent: isTransparent,
    );
    return state!.pushReplacement(route);
  }

  Future<dynamic> replaceRoot(
    Widget newRoot, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route = _materialRoute(
      newRoot,
      isDialog: isDialog,
      isTransparent: isTransparent,
    );
    return state!.pushAndRemoveUntil(route, (route) => false);
  }

  void popTop() {
    context!.read(loginVM).drawerHandler(false);

    state!.pop(true);
  }

  Future<dynamic> pushTo(
    Widget page, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    final route = _materialRoute(
      page,
      isDialog: isDialog,
      isTransparent: isTransparent,
    );
    return state!.push(route);
  }

  MaterialPageRoute<Object> _materialRoute(
    Widget widget, {
    bool isDialog = false,
    bool isTransparent = false,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: isDialog,
      builder: (BuildContext context) => widget,
    );
  }

  void popToFirst() => state!.popUntil((route) => route.isFirst);

  void popView() => state!.pop();

  bool get canPop => state!.canPop();
}

extension MyNavigator on BuildContext {
  Future navigateReplace(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.replaceTop(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  Future navigate(
    Widget route, {
    bool isDialog = false,
    bool isTransparent = false,
  }) =>
      navigator.pushTo(
        route,
        isDialog: isDialog,
        isTransparent: isTransparent,
      );

  void popToFirst() => navigator.popToFirst();

  void popView() => navigator.popView();

  bool get canPop => navigator.canPop;
}

class FadeInRoute<T> extends MaterialPageRoute<T> {
  FadeInRoute({WidgetBuilder? builder, RouteSettings? settings})
      : super(builder: builder!, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: new SlideTransition(
            position: new Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -1.0),
            ).animate(secondaryAnimation),
            child: result,
          ),
        ),
      ),
    );
  }
}
