import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/profile/presentation/providers/profile_provider.dart';
import 'package:afterhours/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(profileDisplayNameProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 42),
              Center(
                child: Text(
                  'HI. $displayName!',
                  style: AppTextStyles.displayTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 46),
              ProfileMenuTile(
                title: 'ORDERS',
                subtitle: 'View your orders details',
                icon: Icons.shopping_bag_outlined,
                onTap: () => context.push(AppRoutes.orders),
              ),
              const SizedBox(height: 20),
              ProfileMenuTile(
                title: 'PROFILE',
                icon: Icons.person_outline,
                onTap: () => context.push(AppRoutes.profileInfo),
              ),
              const SizedBox(height: 20),
              ProfileMenuTile(
                title: 'ADDRESSES',
                icon: Icons.location_on_outlined,
                onTap: () => context.push(AppRoutes.profileAddress),
              ),
              const SizedBox(height: 20),
              ProfileActionButton(
                label: 'LOG OUT',
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.sectionLabel.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: AppTextStyles.helperText.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(icon, color: AppColors.white, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
