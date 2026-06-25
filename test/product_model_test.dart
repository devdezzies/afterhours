import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses products using the backend product contract', () {
    final product = ProductModel.fromJson({
      'id': 'product-1',
      'name': 'Keyboard',
      'description': 'Mechanical keyboard',
      'price': 1500000,
      'stock': 3,
      'category_id': 1,
      'category': 'peripherals',
      'image_url': 'https://example.com/keyboard.jpg',
    });

    expect(product.id, 'product-1');
    expect(product.price, 1500000);
    expect(product.stock, 3);
    expect(product.category, 'peripherals');
    expect(product.toJson()['category'], 'peripherals');
  });

  test('preserves unknown backend categories without crashing', () {
    final product = ProductModel.fromJson({
      'id': 'product-2',
      'name': 'Standing Lamp',
      'description': 'New backend category',
      'price': 500000,
      'stock': 1,
      'category': 'lighting_and_decor',
      'image_url': null,
    });

    expect(product.category, 'lighting_and_decor');
    expect(product.toJson()['category'], 'lighting_and_decor');
    expect(product.imageUrl, '');
  });
}
