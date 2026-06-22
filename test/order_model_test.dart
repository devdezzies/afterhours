import 'package:afterhours/core/constants/app_constants.dart';
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
}
