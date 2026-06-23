import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : const <String, dynamic>{};
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: product['name']?.toString() ?? 'Unavailable product',
      imageUrl: product['image_url']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['price_at_purchase'] as num?)?.round() ?? 0,
      subtotal: (json['subtotal'] as num?)?.round() ?? 0,
    );
  }
}

class ShippingAddressModel {
  final String address;
  final String city;
  final String countryRegion;
  final String postcode;
  final String phoneNumber;

  const ShippingAddressModel({
    this.address = '',
    this.city = '',
    this.countryRegion = '',
    this.postcode = '',
    this.phoneNumber = '',
  });

  factory ShippingAddressModel.fromJson(dynamic json) {
    if (json is String) return ShippingAddressModel(address: json);
    if (json is! Map<String, dynamic>) return const ShippingAddressModel();
    return ShippingAddressModel(
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      countryRegion: json['country_region']?.toString() ?? '',
      postcode: json['postcode']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final int totalAmount;
  final OrderStatus status;
  final List<OrderItemModel> items;
  final ShippingAddressModel shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.items,
    required this.shippingAddress,
    this.createdAt,
    this.updatedAt,
  });

  OrderItemModel? get leadItem => items.isEmpty ? null : items.first;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return OrderModel(
      id: json['id']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.round() ?? 0,
      status: OrderStatus.fromString(json['status']?.toString() ?? 'pending'),
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(OrderItemModel.fromJson)
          .toList(),
      shippingAddress: ShippingAddressModel.fromJson(json['shipping_address']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  String get formattedPrice => formatIdr(totalAmount);
}

class OrdersResponse {
  final List<OrderModel> orders;
  const OrdersResponse({required this.orders});

  factory OrdersResponse.fromJson(dynamic json) {
    final raw = json is Map<String, dynamic>
        ? json['data'] as List<dynamic>? ?? const []
        : const <dynamic>[];
    return OrdersResponse(
      orders: raw
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList(),
    );
  }
}

String formatIdr(num amount) {
  final value = amount.round().toString();
  return '${AppConstants.currencyPrefix} ${value.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  )}';
}

extension OrderStatusPresentation on OrderStatus {
  Color get color => switch (this) {
    OrderStatus.pending => AppColors.warning,
    OrderStatus.processing => AppColors.yellow,
    OrderStatus.shipped => AppColors.red,
    OrderStatus.delivered => AppColors.success,
    OrderStatus.cancelled => AppColors.textMuted,
  };
}
