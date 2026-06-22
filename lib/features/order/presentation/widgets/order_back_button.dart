import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderBackButton extends StatelessWidget {
  const OrderBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 32),
      child: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.profile);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: AppColors.navPill,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '<<',
                style: AppTextStyles.navLabel.copyWith(
                  color: AppColors.red,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Back',
                style: AppTextStyles.navLabel.copyWith(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
