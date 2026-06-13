import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDark;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isDark ? AppColors.black : AppColors.white,
          foregroundColor: isDark ? AppColors.white : AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          textStyle: isDark
              ? AppTextStyles.buttonSecondary
              : AppTextStyles.button,
        ),
        child: Text(label),
      ),
    );
  }
}
