import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/cart/presentation/providers/cart_provider.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/product/presentation/providers/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productDetailProvider(productId));

    return Scaffold(
      body: product.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ProductDetailError(
          message: error.toString(),
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
        ),
        data: (product) => ProductOverview(product: product),
      ),
    );
  }
}

class ProductOverview extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductOverview({super.key, required this.product});

  @override
  ConsumerState<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends ConsumerState<ProductOverview> {
  bool _isExpanded = false;

  void _addToCart() {
    final product = widget.product;
    ref
        .read(cartProvider.notifier)
        .addItem(
          CartItemModel(
            productId: product.id,
            productName: product.name,
            priceSnapshot: product.price,
            quantity: 1,
            imageUrl: product.imageUrl,
            category: product.category.toApiString(),
          ),
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(AppSnackBar.info('${product.name} added to cart'));
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          children: [
            ProductHeroImage(imageUrl: product.imageUrl),
            const SizedBox(height: 20),
            ProductInfoPanel(
              product: product,
              isExpanded: _isExpanded,
              onReadMore: () => setState(() => _isExpanded = true),
              onAddToCart: product.stock > 0 ? _addToCart : null,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductHeroImage extends StatelessWidget {
  final String imageUrl;

  const ProductHeroImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.65,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: imageUrl.isEmpty
                ? const ProductImageFallback()
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ProductImageFallback(),
                  ),
          ),
          Positioned(
            top: 10,
            right: 14,
            child: ProductIconButton(
              icon: Icons.close,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
            ),
          ),
          const Positioned(
            right: 14,
            bottom: 10,
            child: ProductIconButton(icon: Icons.fullscreen),
          ),
        ],
      ),
    );
  }
}

class ProductInfoPanel extends StatelessWidget {
  final ProductModel product;
  final bool isExpanded;
  final VoidCallback onReadMore;
  final VoidCallback? onAddToCart;

  const ProductInfoPanel({
    super.key,
    required this.product,
    required this.isExpanded,
    required this.onReadMore,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 42),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '~ ${product.name.toUpperCase()}',
            style: AppTextStyles.sectionLabel.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 14),
          Text(
            product.description,
            maxLines: isExpanded ? null : 5,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.fade,
            style: AppTextStyles.bodyMono.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.2,
            ),
          ),
          if (!isExpanded) ...[
            const SizedBox(height: 2),
            GestureDetector(
              onTap: onReadMore,
              child: Text(
                '> READ MORE',
                style: AppTextStyles.sectionMeta.copyWith(fontSize: 12),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ProductAddToCartButton(
            price: product.formattedPrice,
            onPressed: onAddToCart,
          ),
        ],
      ),
    );
  }
}

class ProductAddToCartButton extends StatelessWidget {
  final String price;
  final VoidCallback? onPressed;

  const ProductAddToCartButton({
    super.key,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = onPressed == null ? AppColors.textMuted : AppColors.yellow;

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(
                Icons.apps_rounded,
                color: AppColors.black,
                size: 20,
              ),
            ),
            Expanded(
              child: Text(
                onPressed == null ? 'OUT OF STOCK' : '$price + ADD TO CART',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonSecondary.copyWith(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class ProductIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ProductIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 30,
        height: 30,
        color: AppColors.black,
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}

class ProductImageFallback extends StatelessWidget {
  const ProductImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textMuted,
          size: 42,
        ),
      ),
    );
  }
}

class ProductDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductDetailError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: AppTextStyles.errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('RETRY')),
          ],
        ),
      ),
    );
  }
}

extension ProductPriceFormatter on ProductModel {
  String get formattedPrice {
    final value = price.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < value.length; i++) {
      final position = value.length - i;
      buffer.write(value[i]);
      if (position > 1 && position % 3 == 1) {
        buffer.write('.');
      }
    }

    return '${AppConstants.currencyPrefix} ${buffer.toString()}';
  }
}
