import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle( 
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.light,
    )
  );

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Hive.openBox<CartItemModel>('cartBox');
  // register cart adapter 
  
  final container = ProviderContainer();
  configureDio401Handler(() async {
    await container.read(authProvider.notifier).logout();
  });

  runApp(
    UncontrolledProviderScope(
      container: container, 
      child: const MyApp(),
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AfterHours',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
