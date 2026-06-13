import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum OrderDisplayStatus {
  waiting,
  shipped,
  confirmed;

  static OrderDisplayStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'waiting':
      case 'pending':
      case 'processing':
        return OrderDisplayStatus.waiting;
      case 'shipped':
      case 'delivered':
        return OrderDisplayStatus.shipped;
      case 'confirmed':
      case 'completed':
      case 'paid':
        return OrderDisplayStatus.confirmed;
      default:
        return OrderDisplayStatus.waiting;
    }
  }

  String get displayName {
    switch (this) {
      case OrderDisplayStatus.waiting:
        return 'WAITING';
      case OrderDisplayStatus.shipped:
        return 'SHIPPED';
      case OrderDisplayStatus.confirmed:
        return 'CONFIRMED';
    }
  }

  Color get color {
    switch (this) {
      case OrderDisplayStatus.waiting:
        return AppColors.warning;
      case OrderDisplayStatus.shipped:
        return AppColors.red;
      case OrderDisplayStatus.confirmed:
        return AppColors.success;
    }
  }
}

class OrderModel {
  final String id;
  final String productId;
  final String productName;
  final String imageUrl;
  final double totalPrice;
  final OrderDisplayStatus status;

  const OrderModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.totalPrice,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final product = _readProductJson(json);
    final productName = _readString(product, [
      'name',
      'product_name',
      'title',
    ], fallback: _readString(json, ['product_name', 'name', 'title']));
    final imageUrl = _readString(product, [
      'image_url',
      'imageUrl',
      'image',
    ], fallback: _readString(json, ['image_url', 'imageUrl', 'image']));
    final price = _readNumber(json, [
      'total_price',
      'total',
      'amount',
      'price',
      'subtotal',
    ]);

    return OrderModel(
      id: _readString(json, ['id', 'order_id']),
      productId: _readString(product, [
        'id',
        'product_id',
      ], fallback: _readString(json, ['product_id'])),
      productName: productName,
      imageUrl: imageUrl,
      totalPrice: price,
      status: OrderDisplayStatus.fromString(
        _readString(json, ['status', 'order_status']),
      ),
    );
  }

  static Map<String, dynamic> _readProductJson(Map<String, dynamic> json) {
    final product = json['product'];
    if (product is Map<String, dynamic>) return product;

    final item = json['item'];
    if (item is Map<String, dynamic>) {
      final itemProduct = item['product'];
      if (itemProduct is Map<String, dynamic>) return itemProduct;
      return item;
    }

    final items = json['items'] ?? json['order_items'];
    if (items is List && items.isNotEmpty) {
      final first = items.first;
      if (first is Map<String, dynamic>) {
        final itemProduct = first['product'];
        if (itemProduct is Map<String, dynamic>) return itemProduct;
        return first;
      }
    }

    return const {};
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  static double _readNumber(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }
}

class OrdersResponse {
  final List<OrderModel> orders;

  const OrdersResponse({required this.orders});

  factory OrdersResponse.fromJson(dynamic json) {
    final rawOrders = switch (json) {
      {'data': final List<dynamic> data} => data,
      {'orders': final List<dynamic> orders} => orders,
      final List<dynamic> list => list,
      _ => const <dynamic>[],
    };

    return OrdersResponse(
      orders: rawOrders
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .where((order) => order.productName.isNotEmpty)
          .toList(),
    );
  }
}

extension OrderPriceFormatter on OrderModel {
  String get formattedPrice {
    final value = totalPrice.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < value.length; i++) {
      final position = value.length - i;
      buffer.write(value[i]);
      if (position > 1 && position % 3 == 1) {
        buffer.write('.');
      }
    }

    return '${AppConstants.currencyPrefix} ${buffer.toString()}';
  }
}
