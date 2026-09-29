// lib/screens/auth/landing_screen.dart
// Langkah F: Menggunakan named routes via AppRoutes

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke Login Screen setelah 2 detik menggunakan named route
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Poin 4: Check if (!mounted) return
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Iconsax.location_tick,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'OdoTrack',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ride, always on track',
              style: AppTextStyles.bodyLight,
            ),
          ],
        ),
      ),
    );
  }
}
