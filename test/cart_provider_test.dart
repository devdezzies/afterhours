import 'dart:io';

import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/cart/data/repositories/checkout_repository.dart';
import 'package:afterhours/features/cart/presentation/providers/cart_provider.dart';
import 'package:afterhours/features/order/data/models/order_model.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class FakeCheckoutRepository implements CheckoutRepository {
  @override
  Ref get ref => throw UnimplementedError();

  @override
  Map<String, dynamic> checkoutPayload({
    required List<CartItemModel> items,
    required ProfileModel profile,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<CartValidation>> validate(List<CartItemModel> items) async {
    return ApiSuccess(
      CartValidation(
        items: items
            .map(
              (item) => ValidatedCartItem(
                productId: item.productId,
                name: item.productName,
                imageUrl: item.imageUrl,
                quantity: item.quantity,
                availableStock: 10,
                unitPrice: item.priceSnapshot.round(),
                lineTotal: item.lineTotal.round(),
              ),
            )
            .toList(),
        removedProductIds: const [],
        subtotal: items.fold(0, (sum, item) => sum + item.lineTotal.round()),
        messages: const [],
      ),
    );
  }

  @override
  Future<ApiResult<CheckoutResult>> checkout({
    required List<CartItemModel> items,
    required ProfileModel profile,
    required String idempotencyKey,
  }) async {
    return ApiSuccess(
      CheckoutResult(
        order: OrderModel(
          id: 'order-1',
          totalAmount: items.fold(
            0,
            (sum, item) => sum + item.lineTotal.round(),
          ),
          status: OrderStatus.pending,
          items: const [],
          shippingAddress: const ShippingAddressModel(address: 'Jalan Satu'),
        ),
        idempotentReplay: false,
      ),
    );
  }
}

void main() {
  test('checkout clears cart state and persisted user items on success', () async {
    final directory = await Directory.systemTemp.createTemp(
      'afterhours-cart-provider-',
    );
    Hive.init(directory.path);
    if (!Hive.isAdapterRegistered(AppConstants.cartItemTypeId)) {
      Hive.registerAdapter(CartItemModelAdapter());
    }
    final box = await Hive.openBox<CartItemModel>('cartBox');

    final container = ProviderContainer(
      overrides: [
        currentUserIdProvider.overrideWithValue('user-1'),
        checkoutRepositoryProvider.overrideWithValue(FakeCheckoutRepository()),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(() async {
      await box.deleteFromDisk();
      await directory.delete(recursive: true);
    });

    final notifier = container.read(cartProvider.notifier);
    notifier.addItem(
      CartItemModel(
        productId: 'product-1',
        productName: 'Keyboard',
        priceSnapshot: 1500000,
        quantity: 1,
      ),
    );

    expect(container.read(cartProvider).isEmpty, isFalse);
    expect(box.keys, contains('user-1:product-1'));

    final result = await notifier.checkout(
      const ProfileModel(
        name: 'Customer',
        email: 'customer@example.com',
        address: 'Jalan Satu',
        city: 'Jakarta',
        countryRegion: 'Indonesia',
        postcode: '12345',
        phoneNumber: '0812',
      ),
    );

    expect(result, isA<ApiSuccess<CheckoutResult>>());
    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(
      box.keys.where((key) => key.toString().startsWith('user-1:')),
      isEmpty,
    );
  });
}
