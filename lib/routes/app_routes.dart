// lib/routes/app_routes.dart
// Langkah C & F: Konstanta named routes + onGenerateRoute
// Semua navigasi antar-screen wajib memakai konstanta ini.

import 'package:flutter/material.dart';
import '../screens/auth/landing_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/detail_kendaraan_screen.dart';
import '../screens/home/form_catatan_screen.dart';
import '../models/kendaraan_model.dart';
import '../models/catatan_servis_model.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String detailKendaraan = '/detail-kendaraan'; // Langkah G
  static const String formCatatan = '/form-catatan';         // Langkah H

  // Langkah F: onGenerateRoute — memeriksa tipe arguments dengan "is" (poin 7)
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        // Langkah F: Home menerima nickname (String) dari Login
        final args = settings.arguments;
        final String nickname = args is String ? args : 'User';
        return MaterialPageRoute(
          builder: (_) => HomeScreen(nickname: nickname),
        );

      case detailKendaraan:
        // Langkah G: Detail menerima objek Kendaraan dari Home
        final args = settings.arguments;
        if (args is Kendaraan) {
          return MaterialPageRoute(
            builder: (_) => DetailKendaraanScreen(kendaraan: args),
          );
        }
        return _errorRoute(settings.name);

      case formCatatan:
        // Langkah H: Form Catatan menerima Kendaraan, mengembalikan CatatanServis
        // poin 8: MaterialPageRoute<CatatanServis> agar tipe kembalian sesuai
        final args = settings.arguments;
        if (args is Kendaraan) {
          return MaterialPageRoute<CatatanServis>(
            builder: (_) => FormCatatanScreen(kendaraan: args),
          );
        }
        return _errorRoute(settings.name);

      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('Route "$name" tidak ditemukan')),
      ),
    );
  }
}
