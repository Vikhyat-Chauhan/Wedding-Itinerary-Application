import 'package:flutter/material.dart';
import 'package:weddingitinerary/presentation/event_screen/event_screen.dart';
import 'package:weddingitinerary/presentation/home_screen/home_screen.dart';
import 'package:weddingitinerary/presentation/test_screen/test_screen.dart';
import '../../core/constants/strings.dart';
import '../../core/exceptions/route_exception.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(
            title: Strings.homeScreenTitle,
          ),
        );
      case '/test':
        return MaterialPageRoute(
          builder: (_) => const TestScreen(
            title: "Just testing",
          ),
        );
      default:
        throw const RouteException('Route not found!');
    }
  }
}
