import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/not_found_screen.dart';
import '../models/kendaraan_model.dart';
import '../screens/home/detail_screen.dart';
import '../screens/home/catatan_form_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String catatanForm = '/catatan-form';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case detail:
        final args = settings.arguments;
        if (args is Kendaraan) {
          return MaterialPageRoute<void>(
            builder: (_) => DetailScreen(kendaraan: args),
            settings: settings,
          );
        }
        return null;
      case catatanForm:
        return MaterialPageRoute<String>(
          builder: (_) => const CatatanFormScreen(),
          settings: settings,
        );
      default:
        return null; // route tidak terdaftar -> halaman 404
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => NotFoundScreen(routeName: settings.name),
      settings: settings,
    );
  }
}
