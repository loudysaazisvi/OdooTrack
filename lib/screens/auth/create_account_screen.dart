import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';
import '../../routes/app_routes.dart';
import '../../utils/validators.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Create Your Account",
                    style: AppTextStyles.heading1,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Please fill in your details to create your account and enjoy our services.",
                    style: AppTextStyles.bodyLight,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: 'Full Name',
                  hintText: 'Full Name',
                  controller: _nameController,
                  prefixIcon: Iconsax.user,
                  validator: (v) => Validators.required(v, 'Nama lengkap'),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Email',
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Iconsax.sms,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Password',
                  hintText: 'password',
                  isPassword: true,
                  controller: _passwordController,
                  prefixIcon: Iconsax.lock,
                  validator: Validators.password,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text.trim();
                      final nickname = name.isNotEmpty ? name.split(' ').first : 'User';
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                        arguments: nickname,
                      );
                    }
                  },
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
                      "Already have an account? ",
                      style: AppTextStyles.bodyLight,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: Text(
                        'Log In',
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
