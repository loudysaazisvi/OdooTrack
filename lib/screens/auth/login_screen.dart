// lib/screens/auth/login_screen.dart
// Langkah D & F: Form & Validasi, Controllers, Loading state, Named routes ke Home

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';
import '../../utils/validators.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Poin 1: Form dan GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  // Poin 2: Input teks menggunakan TextEditingController
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Poin 3 & 5: Status tampilan loading
  bool _isLoading = false;

  // Poin 2: Membuang semua controller di dispose()
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Poin 3: Proses asinkron login dengan try/catch/finally
  Future<void> _handleLogin() async {
    // Poin 1: Validasi form sebelum proses
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Poin 3: Simulasi/proses async
      await Future.delayed(const Duration(seconds: 1));

      // Poin 4: Periksa if (!mounted) return sesudah await
      if (!mounted) return;

      // Ambil nickname dari email untuk dikirim sebagai arguments
      final emailText = _emailController.text.trim();
      String nickname = emailText.split('@').first;
      if (nickname.isNotEmpty) {
        nickname = nickname[0].toUpperCase() + nickname.substring(1);
      }

      // Poin 6 & 7: Named routes & mengirim arguments ke Home
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: nickname,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      // Poin 3: Matikan indikator loading di blok finally
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // Poin 1: Form Widget
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Hi, Welcome Back!",
                    style: AppTextStyles.heading1,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "We're glad to see you again. Log in to manage your fleet and explore new features.",
                    style: AppTextStyles.bodyLight,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                // Poin 1: Validasi email dari Validators.email
                CustomTextField(
                  label: 'Your Email',
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Iconsax.sms,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                // Poin 1: Validasi password dari Validators.password
                CustomTextField(
                  label: 'Password',
                  hintText: 'Password',
                  isPassword: true,
                  controller: _passwordController,
                  prefixIcon: Iconsax.lock,
                  validator: Validators.password,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Poin 3 & 5: Status loading pada tombol
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Continue',
                        onPressed: _handleLogin,
                      ),
                const SizedBox(height: 32),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialLoginMiniButton(
                      iconData: Icons.g_mobiledata,
                      iconColor: Colors.redAccent,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    SocialLoginMiniButton(
                      iconData: Icons.facebook,
                      iconColor: Colors.blue,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    SocialLoginMiniButton(
                      iconData: Icons.apple,
                      iconColor: Colors.black,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
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
      ),
    );
  }
}
