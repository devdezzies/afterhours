import 'package:afterhours/core/theme/app_theme.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:afterhours/features/order/presentation/providers/order_provider.dart';
import 'package:afterhours/features/order/presentation/widgets/order_back_button.dart';
import 'package:afterhours/features/order/presentation/widgets/order_card.dart';
import 'package:afterhours/features/order/presentation/widgets/orders_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text('MY ORDERS', style: AppTextStyles.displayTitle),
                const SizedBox(height: 42),
                Expanded(
                  child: orders.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => OrderErrorState(
                      message: error.toString(),
                      onRetry: () => ref.read(orderProvider.notifier).refresh(),
                    ),
                    data: (orders) => orders.isEmpty
                        ? const OrdersEmptyState()
                        : OrdersList(orders: orders),
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: OrderBackButton(),
          ),
        ],
      ),
    );
  }
}

class OrdersList extends ConsumerWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.red,
      backgroundColor: AppColors.surface,
      onRefresh: () => ref.read(orderProvider.notifier).refresh(),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 132),
        itemBuilder: (context, index) => OrderCard(order: orders[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemCount: orders.length,
      ),
    );
  }
}

class OrderErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const OrderErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              child: OutlinedButton(
                onPressed: onRetry,
                child: const Text('RETRY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
