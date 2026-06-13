import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/product/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDetailProvider = FutureProvider.autoDispose
    .family<ProductModel, String>((ref, productId) async {
      final result = await ref
          .watch(productRepositoryProvider)
          .getProductById(productId);

      switch (result) {
        case ApiSuccess(:final data):
          return data;
        case ApiFailure(:final message):
          throw Exception(message);
      }
    });
