import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:afterhours/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailProvider(orderId));
    return Scaffold(
      appBar: AppBar(title: const Text('ORDER DETAILS')),
      body: order.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (order) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(order.id, style: AppTextStyles.helperText),
            const SizedBox(height: 8),
            Text(
              order.status.displayName,
              style: AppTextStyles.sectionLabel.copyWith(
                color: order.status.color,
              ),
            ),
            const SizedBox(height: 20),
            ...order.items.map((item) => _OrderLine(item: item)),
            const SizedBox(height: 20),
            Text('SHIPPING', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 8),
            Text(
              [
                order.shippingAddress.address,
                order.shippingAddress.city,
                order.shippingAddress.countryRegion,
                order.shippingAddress.postcode,
                order.shippingAddress.phoneNumber,
              ].where((value) => value.isNotEmpty).join('\n'),
              style: AppTextStyles.bodyMono,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL', style: AppTextStyles.sectionLabel),
                Text(order.formattedPrice, style: AppTextStyles.price),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderLine extends StatelessWidget {
  final OrderItemModel item;
  const _OrderLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: item.imageUrl.isEmpty
            ? const Icon(Icons.inventory_2_outlined)
            : Image.network(
                item.imageUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
        title: Text(item.productName),
        subtitle: Text('${item.quantity} × ${formatIdr(item.unitPrice)}'),
        trailing: Text(formatIdr(item.subtotal)),
      ),
    );
  }
}
