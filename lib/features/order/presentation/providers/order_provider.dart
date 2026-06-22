import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:afterhours/features/order/data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderController extends AsyncNotifier<List<OrderModel>> {
  @override
  Future<List<OrderModel>> build() async {
    final result = await ref.watch(orderRepositoryProvider).getOrders();

    switch (result) {
      case ApiSuccess(:final data):
        return data;
      case ApiFailure(:final message):
        throw Exception(message);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final orderProvider = AsyncNotifierProvider<OrderController, List<OrderModel>>(
  OrderController.new,
);

final orderDetailProvider = FutureProvider.autoDispose
    .family<OrderModel, String>((ref, id) async {
      final result = await ref.watch(orderRepositoryProvider).getOrder(id);
      return switch (result) {
        ApiSuccess(:final data) => data,
        ApiFailure(:final message) => throw Exception(message),
      };
    });
