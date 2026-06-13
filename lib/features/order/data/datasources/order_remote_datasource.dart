import 'package:afterhours/core/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRemoteDatasource {
  final Dio dio;

  const OrderRemoteDatasource(this.dio);

  Future<dynamic> fetchOrders() async {
    final response = await dio.get('/orders');
    return response.data;
  }
}

final orderRemoteDatasourceProvider = Provider<OrderRemoteDatasource>((ref) {
  return OrderRemoteDatasource(ref.watch(dioProvider));
});
