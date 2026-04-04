import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerWidget {
  final Widget child; 
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location.startsWith('/cart')) currentIndex = 1; 
    if (location.startsWith('/profile')) currentIndex = 2;

    return Scaffold( 
      extendBody: true,
      body: child, 
      bottomNavigationBar: PillNavBar(currentIndex: currentIndex, cartCount: cartState.totalItems, onTap: (index) {
        switch (index) {
          case 0: context.go('/home'); break;
          case 1: context.go('/cart'); break;
          case 2: context.go('/profile'); break;
        }
      }),
    );
  }
}

class PillNavBar extends StatelessWidget {
  final int currentIndex; 
  final int cartCount; 
  final ValueChanged<int> onTap;

  const PillNavBar({super.key, required this.currentIndex, required this.cartCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 50, right: 50), 
      child: Container( 
        height: 79,  
        decoration: BoxDecoration( 
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.50), 
              blurRadius: 10, 
              offset: const Offset(0, 0)
            )
          ],
          color: AppColors.navPill, 
          borderRadius: BorderRadius.circular(AppRadius.navPill)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            NavTab(label: 'HOME', index: 0, currentIndex: currentIndex, onTap: onTap,), 
            NavTab(label: 'CART', index: 1, currentIndex: currentIndex, onTap: onTap, badge: cartCount > 0 ? cartCount : null),
            NavTab(label: 'PRFL', index: 2, currentIndex: currentIndex, onTap: onTap,)
          ],
        ),
      )
    ); 
  }
}

class NavTab extends StatelessWidget {
  final String label;
  final int index; 
  final int currentIndex; 
  final ValueChanged<int> onTap;
  final int? badge;

  const NavTab({super.key, required this.label, required this.index, required this.currentIndex, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector( 
      onTap: () => onTap(index), 
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8), 
        child: Stack(
          clipBehavior: Clip.none, 
          children: [ 
            Text(label, style: AppTextStyles.navLabel.copyWith(color: isActive ? AppColors.red : AppColors.white)), 
            if (badge != null) 
              Positioned(
                top: -6, 
                right: -10, 
                child: Container( 
                  width: 16, 
                  height: 16, 
                  decoration: const BoxDecoration( 
                    color: AppColors.red, 
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Text(badge! > 9 ? '9+' : '$badge', style: const TextStyle(
                      color: AppColors.white, 
                      fontSize: 8, 
                      fontFamily: AppFonts.ndot
                    )),
                  ),
                ),
              )
          ],
        ),
      )
    );
  }
}