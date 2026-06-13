import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/home/presentation/widgets/product_card.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    setState(() => _query = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(searchProductsProvider(_query));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) context.pop();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      '<<',
                      style: AppTextStyles.navLabel.copyWith(
                        color: AppColors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: AppTextStyles.inputValue,
                      cursorColor: AppColors.red,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _submit,
                      decoration: const InputDecoration(
                        hintText: 'SEARCH PRODUCT',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SearchResultBody(query: _query, products: products),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultBody extends StatelessWidget {
  final String query;
  final AsyncValue<List<ProductModel>> products;

  const SearchResultBody({
    super.key,
    required this.query,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Type then press enter',
          style: AppTextStyles.helperText.copyWith(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
      );
    }

    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Text(
            error.toString(),
            style: AppTextStyles.errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No products found',
              style: AppTextStyles.bodyMono.copyWith(color: AppColors.red),
            ),
          );
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => ProductCard(
            product: items[index],
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}
