import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRemoteDatasource {
  final Dio dio;
  const ProductRemoteDatasource(this.dio);

  Future<Map<String, dynamic>> fetchProducts({
    int page = 1,
    int? perPage,
    String? category,
    double? maxPrice,
    List<String>? keywords,
  }) async {
    final queryParams = {
      'page': page,
      'per_page': perPage ?? AppConstants.pageSize,
      if (category != null && category.isNotEmpty) 'category': category,
      'max_price': ?maxPrice,
      if (keywords != null && keywords.isNotEmpty)
        'keywords': keywords.join(','),
    };

    final response = await dio.get('/products', queryParameters: queryParams);

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchProductById(String id) async {
    final response = await dio.get('/products/$id');
    return response.data as Map<String, dynamic>;
  }
}

final productRemoteDatasourceProvider = Provider<ProductRemoteDatasource>((
  ref,
) {
  return ProductRemoteDatasource(ref.watch(dioProvider));
});
