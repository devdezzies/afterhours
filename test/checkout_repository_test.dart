import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/cart/data/repositories/checkout_repository.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('checkout payload includes saved profile coordinates', () {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final repo = container.read(checkoutRepositoryProvider);
    final payload = repo.checkoutPayload(
      items: [
        CartItemModel(
          productId: 'product-1',
          productName: 'Keyboard',
          priceSnapshot: 1500000,
          quantity: 2,
        ),
      ],
      profile: const ProfileModel(
        name: 'Customer',
        email: 'customer@example.com',
        address: 'Jalan Satu',
        city: 'Jakarta',
        countryRegion: 'Indonesia',
        postcode: '12345',
        phoneNumber: '0812',
        latitude: -6.2,
        longitude: 106.8,
      ),
    );

    expect(payload['items'], [
      {'product_id': 'product-1', 'quantity': 2},
    ]);
    expect(payload['shipping_address'], {
      'address': 'Jalan Satu',
      'city': 'Jakarta',
      'country_region': 'Indonesia',
      'postcode': '12345',
      'phone_number': '0812',
      'latitude': -6.2,
      'longitude': 106.8,
    });
  });

  test('checkout payload allows nullable coordinates', () {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final payload = container
        .read(checkoutRepositoryProvider)
        .checkoutPayload(
          items: const <CartItemModel>[],
          profile: const ProfileModel(
            name: 'Customer',
            email: 'customer@example.com',
            address: 'Jalan Satu',
            city: 'Jakarta',
            countryRegion: 'Indonesia',
            postcode: '12345',
            phoneNumber: '0812',
          ),
        );

    expect(payload['shipping_address']['latitude'], isNull);
    expect(payload['shipping_address']['longitude'], isNull);
  });
}
