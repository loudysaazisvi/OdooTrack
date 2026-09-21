import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath; // Use asset path or we can use Icons if SVG is not ready. For now let's mock it with Icons if needed, but asset path is better.
  final VoidCallback onPressed;
  final IconData? iconData; // Fallback if no asset
  final Color? iconColor;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.iconPath = '',
    required this.onPressed,
    this.iconData,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null) ...[
            Icon(iconData, color: iconColor, size: 24),
            const SizedBox(width: 12),
          ],
          Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Mini Social Button for the Row in Login/Register
class SocialLoginMiniButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final Color? iconColor;

  const SocialLoginMiniButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Icon(iconData, color: iconColor, size: 24),
        ),
      ),
    );
  }
}
