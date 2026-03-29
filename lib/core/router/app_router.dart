import 'package:afterhours/core/widgets/main_shell.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/auth/presentation/screens/login_screen.dart';
import 'package:afterhours/features/auth/presentation/screens/register_screen.dart';
import 'package:afterhours/features/cart/presentation/screens/cart_screen.dart';
import 'package:afterhours/features/home/presentation/screens/home_screen.dart';
import 'package:afterhours/features/order/presentation/screens/order_screen.dart';
import 'package:afterhours/features/product/presentation/screens/product_detail_screen.dart';
import 'package:afterhours/features/profile/presentation/screens/profile_screen.dart';
import 'package:afterhours/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String cart = '/cart'; 
  static const String profile = '/profile';
  static const String productDetails = '/product/:id';
  static const String orders = '/orders'; 
  static const String search = '/search';
}

const publicRoutes = {AppRoutes.login, AppRoutes.register};
const protectedPref = ['/home', '/cart', '/profile', '/product', '/orders', '/search'];

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      if (previous?.value.runtimeType != next.value.runtimeType) {
        notifyListeners();
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter( 
    initialLocation: AppRoutes.splash, 
    refreshListenable: notifier, 
    debugLogDiagnostics: true, 
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.uri.path;

      if (authState is AsyncLoading) {
        return AppRoutes.splash;
      }

      final isAuthenticated = authState.value is AuthAuthenticated;
      final isPublicOnly = publicRoutes.contains(location); 
      final isProtected = protectedPref.any((p) => location.startsWith(p));

      if (!isAuthenticated && isProtected) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isPublicOnly) {
        return AppRoutes.home;
      } 

      if (location == AppRoutes.splash) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

      return null;
    }, 
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashGate()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),

      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),), 
          GoRoute(path: AppRoutes.cart, pageBuilder: (context, state) => const NoTransitionPage(child: CartScreen()),),
          GoRoute(path: AppRoutes.profile, pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),),
        ]
      ),

      GoRoute(path: AppRoutes.productDetails, builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.orders, builder: (context, state) => const OrderScreen()),
      GoRoute(path: AppRoutes.search, builder: (context, state) => const SearchScreen())
  ]
  );
});

class SplashGate extends StatelessWidget {
  const SplashGate({super.key}); 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Color(0xFF000000),);
  }
}