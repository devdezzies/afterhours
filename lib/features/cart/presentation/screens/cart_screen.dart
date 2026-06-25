import 'package:afterhours/core/router/app_router.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/currency_formatter.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/cart/presentation/providers/cart_provider.dart';
import 'package:afterhours/features/order/presentation/providers/order_provider.dart';
import 'package:afterhours/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _checkingOut = false;

  Future<void> _checkout() async {
    final profile = ref.read(profileProvider).value;
    if (profile == null ||
        profile.address.isEmpty ||
        profile.city.isEmpty ||
        profile.countryRegion.isEmpty ||
        profile.postcode.isEmpty ||
        profile.phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar.info('Complete your address and phone number first.'),
      );
      context.push(AppRoutes.profileAddress);
      return;
    }

    setState(() => _checkingOut = true);
    final result = await ref.read(cartProvider.notifier).checkout(profile);
    if (!mounted) return;
    setState(() => _checkingOut = false);

    switch (result) {
      case ApiSuccess():
        ref.invalidate(orderProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(AppSnackBar.info('Order created successfully.'));
        context.push(AppRoutes.orders);
      case ApiFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.error(message));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('YOUR CART', style: AppTextStyles.sectionLabel),
        centerTitle: true,
      ),
      body: cart.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: AppTextStyles.bodyMono.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          : Column(
              children: [
                if (cart.syncError != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Text(
                      cart.syncError!,
                      style: AppTextStyles.errorMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _CartItemCard(
                      item: cart.items[index],
                      price: formatIdr(cart.items[index].lineTotal),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SUBTOTAL', style: AppTextStyles.sectionLabel),
                            Text(
                              formatIdr(cart.subtotal),
                              style: AppTextStyles.price,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkingOut || cart.isSyncing
                                ? null
                                : _checkout,
                            child: Text(
                              _checkingOut || cart.isSyncing
                                  ? 'VALIDATING...'
                                  : 'CHECKOUT',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItemModel item;
  final String price;

  const _CartItemCard({required this.item, required this.price});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Image.network(
              item.imageUrl,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox(
                width: 82,
                height: 82,
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionLabel.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(price, style: AppTextStyles.price.copyWith(fontSize: 15)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.productId, item.quantity - 1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${item.quantity}', style: AppTextStyles.bodyMono),
                    IconButton(
                      onPressed: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.productId, item.quantity + 1),
                      icon: const Icon(Icons.add),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => ref
                          .read(cartProvider.notifier)
                          .removeItem(item.productId),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
