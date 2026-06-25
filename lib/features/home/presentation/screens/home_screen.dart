import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/home/presentation/providers/home_provider.dart';
import 'package:afterhours/features/home/presentation/widgets/category_row.dart';
import 'package:afterhours/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> refresh() async {
    final categories = await ref.refresh(dynamicCategoriesProvider.future);
    for (final category in categories) {
      ref.invalidate(homeCategoryProvider(category));
    }
    if (categories.isNotEmpty) {
      await ref.read(homeCategoryProvider(categories.first).future);
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = ref.watch(greetingProvider);
    final categoriesAsync = ref.watch(dynamicCategoriesProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.red,
        backgroundColor: AppColors.surface,
        onRefresh: refresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + 28),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Text('$greeting!', style: AppTextStyles.displayTitle),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: InkWell(
                  onTap: () => context.push(AppRoutes.search),
                  borderRadius: BorderRadius.circular(AppRadius.searchBar),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.searchBar),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.red),
                        const SizedBox(width: 12),
                        Text(
                          'SEARCH PRODUCTS',
                          style: AppTextStyles.helperText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ...categoriesAsync.when(
              loading: () => const [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 28),
                    child: _CategoryLoadingState(),
                  ),
                ),
              ],
              error: (error, _) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 36, 20, 0),
                    child: Text(
                      error.toString(),
                      style: AppTextStyles.errorMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              data: (categories) {
                if (categories.isEmpty) {
                  return const [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 36, 20, 0),
                        child: _NoCategoriesState(),
                      ),
                    ),
                  ];
                }

                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: CategoryRow(category: categories[index]),
                      ),
                      childCount: categories.length,
                    ),
                  ),
                ];
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _CategoryLoadingState extends StatelessWidget {
  const _CategoryLoadingState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, _) => ProductCardSkeleton(width: 135, height: 135),
      ),
    );
  }
}

class _NoCategoriesState extends StatelessWidget {
  const _NoCategoriesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No products found',
        style: AppTextStyles.fieldLabel.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
