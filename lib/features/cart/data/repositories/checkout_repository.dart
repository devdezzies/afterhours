import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValidatedCartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final int quantity;
  final int availableStock;
  final int unitPrice;
  final int lineTotal;

  const ValidatedCartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.availableStock,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory ValidatedCartItem.fromJson(Map<String, dynamic> json) {
    return ValidatedCartItem(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      availableStock: (json['available_stock'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.round() ?? 0,
      lineTotal: (json['line_total'] as num?)?.round() ?? 0,
    );
  }
}

class CartValidation {
  final List<ValidatedCartItem> items;
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
        .map(ValidatedCartItem.fromJson)
        .toList(),
    removedProductIds:
        (json['removed_product_ids'] as List<dynamic>? ?? const [])
            .map((value) => value.toString())
            .toList(),
    subtotal: (json['subtotal'] as num?)?.round() ?? 0,
    messages: (json['messages'] as List<dynamic>? ?? const [])
        .map((value) => value.toString())
        .toList(),
  );
}

class CheckoutResult {
  final OrderModel order;
  final bool idempotentReplay;

  const CheckoutResult({required this.order, required this.idempotentReplay});

  factory CheckoutResult.fromJson(Map<String, dynamic> json) {
    return CheckoutResult(
      order: OrderModel.fromJson(json['data'] as Map<String, dynamic>),
      idempotentReplay: json['idempotent_replay'] == true,
    );
  }
}

class CheckoutRepository {
  final Ref ref;
  const CheckoutRepository(this.ref);

  List<Map<String, dynamic>> _items(List<CartItemModel> items) =>
      items.map((item) => item.toSyncPayload()).toList();

  Map<String, dynamic> checkoutPayload({
    required List<CartItemModel> items,
    required ProfileModel profile,
  }) => {
    'items': _items(items),
    'shipping_address': {
      'address': profile.address,
      'city': profile.city,
      'country_region': profile.countryRegion,
      'postcode': profile.postcode,
      'phone_number': profile.phoneNumber,
      'latitude': profile.latitude,
      'longitude': profile.longitude,
    },
  };

  Future<ApiResult<CartValidation>> validate(List<CartItemModel> items) =>
      runApiCall(() async {
        final response = await ref
            .read(dioProvider)
            .post('/cart/validate', data: {'items': _items(items)});
        return CartValidation.fromJson(response.data as Map<String, dynamic>);
      });

  Future<ApiResult<CheckoutResult>> checkout({
    required List<CartItemModel> items,
    required ProfileModel profile,
    required String idempotencyKey,
  }) => runApiCall(() async {
    final response = await ref
        .read(dioProvider)
        .post(
          '/orders',
          options: Options(headers: {'Idempotency-Key': idempotencyKey}),
          data: checkoutPayload(items: items, profile: profile),
        );
    return CheckoutResult.fromJson(response.data as Map<String, dynamic>);
  });
}

final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  CheckoutRepository.new,
);
