import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/product/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProductsProvider = FutureProvider.autoDispose
    .family<List<ProductModel>, String>((ref, query) async {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return const [];

      final result = await ref
          .watch(productRepositoryProvider)
          .getProducts(keywords: trimmedQuery.split(RegExp(r'\s+')));

      switch (result) {
        case ApiSuccess(:final data):
          return data.products;
        case ApiFailure(:final message):
          throw Exception(message);
      }
    });
