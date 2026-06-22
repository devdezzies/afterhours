import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const ProfileInputField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.inputValue.copyWith(color: AppColors.black),
          cursorColor: AppColors.red,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Positioned(
          top: -8,
          left: 14,
          child: Container(
            color: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              label,
              style: AppTextStyles.fieldLabel.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
