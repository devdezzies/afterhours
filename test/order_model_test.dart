import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/features/cart/data/repositories/checkout_repository.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a multi-item order using the backend contract', () {
    final order = OrderModel.fromJson({
      'id': 'order-1',
      'status': 'processing',
      'total_amount': 3500000,
      'shipping_address': {
        'address': 'Jalan Satu',
        'city': 'Jakarta',
        'country_region': 'Indonesia',
        'postcode': '12345',
        'phone_number': '0812',
      },
      'items': [
        {
          'id': 'item-1',
          'product_id': 'product-1',
          'quantity': 2,
          'price_at_purchase': 1500000,
          'subtotal': 3000000,
          'product': {
            'name': 'Keyboard',
            'image_url': 'https://example.com/keyboard.jpg',
          },
        },
        {
          'id': 'item-2',
          'product_id': 'product-2',
          'quantity': 1,
          'price_at_purchase': 500000,
          'subtotal': 500000,
          'product': {
            'name': 'Mouse',
            'image_url': 'https://example.com/mouse.jpg',
          },
        },
      ],
    });

    expect(order.status, OrderStatus.processing);
    expect(order.items, hasLength(2));
    expect(order.leadItem?.productName, 'Keyboard');
    expect(order.shippingAddress.city, 'Jakarta');
    expect(order.formattedPrice, 'RP 3.500.000');
  });

  test('supports all backend order statuses', () {
    for (final status in const [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ]) {
      expect(OrderStatus.fromString(status).name, status);
    }
  });

  test('parses flattened order list shipping fields from backend', () {
    final order = OrderModel.fromJson({
      'id': 'order-2',
      'status': 'pending',
      'total_amount': 1500000,
      'shipping_address': 'Jalan Dua',
      'shipping_city': 'Bandung',
      'shipping_country_region': 'Indonesia',
      'shipping_postcode': '40111',
      'shipping_phone_number': '0813',
      'shipping_lat': -6.9,
      'shipping_lng': 107.6,
      'items': const [],
    });

    expect(order.shippingAddress.address, 'Jalan Dua');
    expect(order.shippingAddress.city, 'Bandung');
    expect(order.shippingAddress.phoneNumber, '0813');
    expect(order.shippingAddress.latitude, -6.9);
    expect(order.shippingAddress.longitude, 107.6);
  });

  test('parses checkout response metadata and nested order detail', () {
    final result = CheckoutResult.fromJson({
      'idempotent_replay': true,
      'data': {
        'id': 'order-3',
        'status': 'pending',
        'total_amount': 500000,
        'shipping_address': {
          'address': 'Jalan Tiga',
          'city': 'Jakarta',
          'country_region': 'Indonesia',
          'postcode': '12345',
          'phone_number': '0812',
          'latitude': null,
          'longitude': null,
        },
        'items': const [],
      },
    });

    expect(result.idempotentReplay, isTrue);
    expect(result.order.id, 'order-3');
    expect(result.order.shippingAddress.city, 'Jakarta');
  });
}
