import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/product/data/models/datasources/product_remote_datasource.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository {
  final ProductRemoteDatasource remoteDataSource;
  
  const ProductRepository(this.remoteDataSource);

  Future<ApiResult<PaginatedProducts>> getProducts({
    int page = 1, 
    ProductCategory? category, 
    double? maxPrice, 
    List<String>? keywords
  }) {
    return runApiCall(() async {
      final json = await remoteDataSource.fetchProducts(
        page: page, 
        category: category, 
        maxPrice: maxPrice, 
        keywords: keywords
      );
      return PaginatedProducts.fromJson(json);
    });
  }

  Future<ApiResult<ProductModel>> getProductById(String id) {
    return runApiCall(() async {
      final json = await remoteDataSource.fetchProductById(id);
      return ProductModel.fromJson(json['data'] as Map<String, dynamic>); 
    });
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(productRemoteDatasourceProvider));
});