import 'package:flutter/material.dart';
import 'package:kynaara_frontend/presentation/screens/home_screen.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';

class RouteConfiguration {
  static Map<String, Widget Function(BuildContext context)> getRoutes() {
    Map<String, Widget Function(BuildContext context)> routes = {};

    routes['login'] = (context) {
      return const LoginScreen();
    };
    routes['dashboard'] = (context) {
      return const HomeScreen();
    };

    return routes;
  }
}
