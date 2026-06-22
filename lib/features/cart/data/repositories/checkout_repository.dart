import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartValidation {
  final List<Map<String, dynamic>> items;
  final List<String> removedProductIds;
  final int subtotal;
  final List<String> messages;

  const CartValidation({
    required this.items,
    required this.removedProductIds,
    required this.subtotal,
    required this.messages,
  });

  factory CartValidation.fromJson(Map<String, dynamic> json) => CartValidation(
    items: (json['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList(),
    removedProductIds: (json['removed_product_ids'] as List<dynamic>? ?? const [])
        .map((value) => value.toString())
        .toList(),
    subtotal: (json['subtotal'] as num?)?.round() ?? 0,
    messages: (json['messages'] as List<dynamic>? ?? const [])
        .map((value) => value.toString())
        .toList(),
  );
}

class CheckoutRepository {
  final Ref ref;
  const CheckoutRepository(this.ref);

  List<Map<String, dynamic>> _items(List<CartItemModel> items) =>
      items.map((item) => item.toSyncPayload()).toList();

  Future<ApiResult<CartValidation>> validate(List<CartItemModel> items) =>
      runApiCall(() async {
        final response = await ref
            .read(dioProvider)
            .post('/cart/validate', data: {'items': _items(items)});
        return CartValidation.fromJson(response.data as Map<String, dynamic>);
      });

  Future<ApiResult<String>> checkout({
    required List<CartItemModel> items,
    required ProfileModel profile,
    required String idempotencyKey,
  }) => runApiCall(() async {
    final response = await ref.read(dioProvider).post(
      '/orders',
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
      data: {
        'items': _items(items),
        'shipping_address': {
          'address': profile.address,
          'city': profile.city,
          'country_region': profile.countryRegion,
          'postcode': profile.postcode,
          'phone_number': profile.phoneNumber,
          'latitude': null,
          'longitude': null,
        },
      },
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return data['id'].toString();
  });
}

final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  CheckoutRepository.new,
);
