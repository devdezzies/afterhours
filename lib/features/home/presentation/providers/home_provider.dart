import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:afterhours/features/product/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final greetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour; 
  if (hour < 12) return 'Good Morning'; 
  if (hour < 17) return 'Good Afternoon'; 
  return 'Good Evening';
});

final homeCategoryProvider = FutureProvider.autoDispose 
  .family<List<ProductModel>, ProductCategory>((ref, category) async {
    final repo = ref.watch(productRepositoryProvider);

    final result = await repo.getProducts(category: category, page: 1);
    
    switch (result) {
      case ApiSuccess(:final data): 
        return data.products.take(20).toList();
      case ApiFailure(:final message): 
        throw Exception('Failed to load products for category ${category.toApiString()}: $message');
    } 
});

final homeUserNameProvider = Provider<String>((ref) {
  final auth = ref.watch(authProvider);
  final state = auth.value; 
  if (state != null && state is AuthAuthenticated) {
    final name = state.username;
    return name.isNotEmpty ? name.split(' ').first.toLowerCase() : '';
  }
  return '';
});