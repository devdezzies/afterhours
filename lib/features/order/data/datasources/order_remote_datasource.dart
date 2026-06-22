import 'package:afterhours/core/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRemoteDatasource {
  final Dio dio;

  const OrderRemoteDatasource(this.dio);

  Future<dynamic> fetchOrders() async {
    final response = await dio.get(
      '/orders',
      queryParameters: {'include': 'items.product'},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> fetchOrder(String id) async {
    final response = await dio.get('/orders/$id');
    return response.data as Map<String, dynamic>;
  }
}

final orderRemoteDatasourceProvider = Provider<OrderRemoteDatasource>((ref) {
  return OrderRemoteDatasource(ref.watch(dioProvider));
});
