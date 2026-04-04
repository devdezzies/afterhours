import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../product/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double width;
  final double height;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 132,
    this.height = 125,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.productDetails.replaceFirst(':id', product.id),
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card), // 5px
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ProductImage(imageUrl: product.imageUrl),
          ],
        ),
      ),
    );
  }

}

class ProductCardSkeleton extends StatefulWidget {
  final double width;
  final double height;
  const ProductCardSkeleton({super.key, this.width = 132, this.height = 125});

  @override
  State<ProductCardSkeleton> createState() => _ProductCardSkeletonState();
}

class _ProductCardSkeletonState extends State<ProductCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(_anim.value + 0.3),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _placeholder();

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: AppColors.textMuted, size: 34),
      ),
    );
}