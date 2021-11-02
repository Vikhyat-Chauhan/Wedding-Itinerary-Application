import 'package:flutter/material.dart';
import 'package:weddingitinerary/presentation/launch_screen/launch_screen.dart';
import 'package:weddingitinerary/presentation/home_screen/home_screen.dart';
import '../../core/constants/strings.dart';
import '../../core/exceptions/route_exception.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const LaunchScreen(
            title: Strings.homeScreenTitle,
          ),
        );
      case '/home_screen':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            title: "Just testing",
          ),
        );
      default:
        throw const RouteException('Route not found!');
    }
  }
}
