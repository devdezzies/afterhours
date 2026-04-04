import 'package:afterhours/features/home/presentation/providers/home_provider.dart';
import 'package:afterhours/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';

import '../../../../core/theme/app_theme.dart';

class CategoryRow extends ConsumerWidget {
  final ProductCategory category;

  const CategoryRow({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(homeCategoryProvider(category));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '> ${category.displayName}',
                style: AppTextStyles.sectionLabel,
              ),

              GestureDetector(
                // onTap: () => Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => , // TODO: implement category product list screen
                //   ),
                // ),
                child: const Text('[more]', style: AppTextStyles.sectionMeta),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 135,
          child: productsAsync.when(
            loading: () => _SkeletonRow(),
            error: (e, _) => _ErrorRow(message: e.toString()),
            data: (products) {
              if (products.isEmpty) {
                return const _EmptyRow();
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ProductCard(product: products[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}


class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, _) => ProductCardSkeleton(width: 135, height: 135),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  final String message;
  const _ErrorRow({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          'failed to load',
          style: AppTextStyles.fieldLabel.copyWith(color: AppColors.redError),
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          'no products',
          style: AppTextStyles.fieldLabel.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}