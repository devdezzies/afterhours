import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/home/presentation/providers/home_provider.dart';
import 'package:afterhours/features/home/presentation/widgets/category_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const categories = [
    ProductCategory.peripherals, 
    ProductCategory.deskAccessories, 
    ProductCategory.audio, 
    ProductCategory.furniture, 
    ProductCategory.eyewear
  ];

  Future<void> refresh() async {
    for (final cat in categories) {
      ref.invalidate(homeCategoryProvider(cat));
    } 
    await ref.read(homeCategoryProvider(categories.first).future);
  }

  @override
  Widget build(BuildContext context) {
    final greeting = ref.watch(greetingProvider); 
    final username = ref.watch(homeUserNameProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.red,
        backgroundColor: AppColors.surface, 
        onRefresh: refresh, 
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox( 
                height: MediaQuery.of(context).padding.top + 28,
              )
            ), 

            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "$greeting${username.isNotEmpty ? ', $username' : ''}!", 
                  style: AppTextStyles.displayTitle,
                ),
              )
            ), 

            // search bar 

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 28), 
                  child: CategoryRow(category: categories[index]),
                  ), 
                  childCount: categories.length
                )
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      )
    );
  }
}