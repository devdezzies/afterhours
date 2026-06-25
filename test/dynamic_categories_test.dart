import 'package:afterhours/features/home/presentation/providers/home_provider.dart';
import 'package:afterhours/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

ProductModel productWithCategory(String? category) {
  return ProductModel(
    id: 'product-${category ?? 'empty'}',
    name: 'Product',
    description: 'Description',
    price: 1000,
    stock: 1,
    category: category ?? '',
    imageUrl: '',
  );
}

void main() {
  test(
    'extractDynamicCategories deduplicates and preserves first seen order',
    () {
      final categories = extractDynamicCategories([
        productWithCategory('peripherals'),
        productWithCategory('desk_accessories'),
        productWithCategory('peripherals'),
        productWithCategory('lighting'),
      ]);

      expect(categories, ['peripherals', 'desk_accessories', 'lighting']);
    },
  );

  test('extractDynamicCategories ignores empty categories', () {
    final categories = extractDynamicCategories([
      productWithCategory(''),
      productWithCategory(null),
      productWithCategory('audio'),
      productWithCategory('   '),
    ]);

    expect(categories, ['audio']);
  });

  test('formatCategoryLabel formats backend category strings', () {
    expect(formatCategoryLabel('desk_accessories'), 'DESK ACCESSORIES');
    expect(formatCategoryLabel('lighting-and-decor'), 'LIGHTING AND DECOR');
    expect(formatCategoryLabel('  audio  '), 'AUDIO');
  });

  test('category route values can be URI encoded and decoded unchanged', () {
    const category = 'lighting and decor';
    final encoded = Uri.encodeComponent(category);

    expect(encoded, 'lighting%20and%20decor');
    expect(Uri.decodeComponent(encoded), category);
  });
}
