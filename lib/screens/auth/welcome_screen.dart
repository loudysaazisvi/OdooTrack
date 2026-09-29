import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                "Let's Get Started!",
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 12),
              Text(
                "Welcome to your journey! We're thrilled to have you here.",
                style: AppTextStyles.bodyLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SocialLoginButton(
                text: 'Continue With Google',
                iconData: Icons.g_mobiledata,
                iconColor: Colors.redAccent,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue With Facebook',
                iconData: Icons.facebook,
                iconColor: Colors.blue,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue With Apple',
                iconData: Icons.apple,
                iconColor: Colors.black,
                onPressed: () {},
              ),
              const Spacer(),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Or', style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyLight,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
