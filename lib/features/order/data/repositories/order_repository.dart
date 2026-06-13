import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/order/data/datasources/order_remote_datasource.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRepository {
  final OrderRemoteDatasource remoteDatasource;

  const OrderRepository(this.remoteDatasource);

  Future<ApiResult<List<OrderModel>>> getOrders() {
    return runApiCall(() async {
      final json = await remoteDatasource.fetchOrders();
      return OrdersResponse.fromJson(json).orders;
    });
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(orderRemoteDatasourceProvider));
});
