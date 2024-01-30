import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

class Navigation {
  final String initialRoute = "/";
  // final navigationHistoryObserver = NavigationHistoryObserver();
  Navigation._privateConstructor();
  static final Navigation instance = Navigation._privateConstructor();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigate(String path, {Object? args}) {
    return navigatorKey.currentState?.pushNamed(path, arguments: args);
  }

  Future<dynamic>? navigateAndReplace(String path, {Object? args}) {
    return navigatorKey.currentState
        ?.pushReplacementNamed(path, arguments: args);
  }

  Future<dynamic>? navigateAndRemoveUntil(String path, {Object? args}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        path, (Route<dynamic> route) => false,
        arguments: args);
  }
  Future<dynamic>? pushNamedIfNotCurrent(String path, {Object? args}) {
    if (navigatorKey.currentState?.canPop() == true) {
      // Check if the current route is not the same as the target route
      if (ModalRoute.of(navigatorKey.currentContext!)?.settings.name != path) {
        // Only push the new route if it's not the current route
        return navigatorKey.currentState?.pushNamed(path, arguments: args);
      }
    } else {
      // If there is no previous route, or if the current route is the target route, simply push the new route
      return navigatorKey.currentState?.pushNamed(path, arguments: args);
    }
    return null;
  }


  goBack() {
    try {
      return navigatorKey.currentState?.pop();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}