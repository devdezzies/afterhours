import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 142,
            height: double.infinity,
            child: OrderProductImage(imageUrl: order.imageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.productName.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.sectionLabel.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '> ${order.status.displayName}',
                    style: AppTextStyles.sectionMeta.copyWith(
                      color: order.status.color,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order.formattedPrice,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.price.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (order.productId.isEmpty) return card;

    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.productDetails.replaceFirst(':id', order.productId),
      ),
      child: card,
    );
  }
}

class OrderProductImage extends StatelessWidget {
  final String imageUrl;

  const OrderProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const OrderImagePlaceholder();

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const OrderImagePlaceholder(),
    );
  }
}

class OrderImagePlaceholder extends StatelessWidget {
  const OrderImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navPill,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textMuted,
          size: 32,
        ),
      ),
    );
  }
}
