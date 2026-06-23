import 'dart:io';

import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  test('CartItemModel adapter preserves every field', () async {
    final directory = await Directory.systemTemp.createTemp(
      'afterhours-cart-adapter-',
    );
    Hive.init(directory.path);
    Hive.registerAdapter(CartItemModelAdapter());

    final original = CartItemModel(
      productId: 'product-1',
      productName: 'Monitor light',
      priceSnapshot: 179000,
      quantity: 2,
      imageUrl: 'https://example.com/light.jpg',
      category: 'lighting',
    );

    final box = await Hive.openBox<CartItemModel>('cart-adapter-test');
    await box.put('product-1', original);
    await box.close();

    final reopened = await Hive.openBox<CartItemModel>('cart-adapter-test');
    final restored = reopened.get('product-1');

    expect(restored, isNotNull);
    expect(restored!.productId, original.productId);
    expect(restored.productName, original.productName);
    expect(restored.priceSnapshot, original.priceSnapshot);
    expect(restored.quantity, original.quantity);
    expect(restored.imageUrl, original.imageUrl);
    expect(restored.category, original.category);

    await reopened.deleteFromDisk();
    await directory.delete(recursive: true);
  });
}
