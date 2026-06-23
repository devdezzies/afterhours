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
    final leadItem = order.leadItem;
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
            child: OrderProductImageGrid(items: order.items),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (leadItem?.productName ?? 'ORDER').toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.sectionLabel.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.items.length} ITEM${order.items.length == 1 ? '' : 'S'}',
                    style: AppTextStyles.helperText,
                  ),
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

    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.orderDetails.replaceFirst(':id', order.id)),
      child: card,
    );
  }
}

class OrderProductImageGrid extends StatelessWidget {
  final List<OrderItemModel> items;

  const OrderProductImageGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final previewItems = items.take(4).toList(growable: false);

    if (previewItems.isEmpty) return const OrderImagePlaceholder();
    if (previewItems.length == 1) {
      return OrderProductImage(imageUrl: previewItems.first.imageUrl);
    }

    const gap = 2.0;

    return ColoredBox(
      color: AppColors.surface,
      child: switch (previewItems.length) {
        2 => Row(
          children: [
            Expanded(
              child: OrderProductImage(imageUrl: previewItems[0].imageUrl),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: OrderProductImage(imageUrl: previewItems[1].imageUrl),
            ),
          ],
        ),
        3 => Row(
          children: [
            Expanded(
              child: OrderProductImage(imageUrl: previewItems[0].imageUrl),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[1].imageUrl,
                    ),
                  ),
                  const SizedBox(height: gap),
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[2].imageUrl,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _ => Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[0].imageUrl,
                    ),
                  ),
                  const SizedBox(width: gap),
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[1].imageUrl,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: gap),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[2].imageUrl,
                    ),
                  ),
                  const SizedBox(width: gap),
                  Expanded(
                    child: OrderProductImage(
                      imageUrl: previewItems[3].imageUrl,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      },
    );
  }
}

class OrderProductImage extends StatelessWidget {
  final String imageUrl;

  const OrderProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const OrderImagePlaceholder();

    return SizedBox.expand(
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, _, _) => const OrderImagePlaceholder(),
      ),
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
