import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/product/data/models/datasources/product_remote_datasource.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository {
  final ProductRemoteDatasource remoteDataSource;

  const ProductRepository(this.remoteDataSource);

  Future<ApiResult<PaginatedProducts>> getProducts({
    int page = 1,
    int? perPage,
    String? category,
    double? maxPrice,
    List<String>? keywords,
  }) {
    return runApiCall(() async {
      final json = await remoteDataSource.fetchProducts(
        page: page,
        perPage: perPage,
        category: category,
        maxPrice: maxPrice,
        keywords: keywords,
      );
      return PaginatedProducts.fromJson(json);
    });
  }

  Future<ApiResult<ProductModel>> getProductById(String id) {
    return runApiCall(() async {
      final json = await remoteDataSource.fetchProductById(id);
      final data = json['data'];
      return ProductModel.fromJson(data is Map<String, dynamic> ? data : json);
    });
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(productRemoteDatasourceProvider));
});
