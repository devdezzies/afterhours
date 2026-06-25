import 'package:afterhours/core/utils/api_result.dart';
import 'dart:math';

import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:afterhours/features/cart/data/repositories/checkout_repository.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_ce_flutter/adapters.dart';

class CartState {
  final List<CartItemModel> items;
  final bool isSyncing;
  final String? syncError;

  const CartState({
    this.items = const [],
    this.isSyncing = false,
    this.syncError,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isSyncing,
    String? syncError,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isSyncing: isSyncing ?? this.isSyncing,
      syncError: clearError ? null : (syncError ?? this.syncError),
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final Box<CartItemModel> cartBox;
  final Ref ref;
  final String userId;
  String? _pendingIdempotencyKey;

  CartNotifier(this.ref, this.cartBox, this.userId)
    : super(
        CartState(
          items: cartBox.keys
              .whereType<String>()
              .where((key) => key.startsWith('$userId:'))
              .map((key) => cartBox.get(key))
              .whereType<CartItemModel>()
              .where((item) => item.productId.isNotEmpty)
              .toList(),
        ),
      );

  String _key(String productId) => '$userId:$productId';

  void addItem(CartItemModel newItem) {
    _pendingIdempotencyKey = null;
    final existingIndex = state.items.indexWhere(
      (i) => i.productId == newItem.productId,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItemModel>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + newItem.quantity,
      );
      persist(updated);
    } else {
      persist([...state.items, newItem]);
    }
  }

  void removeItem(String productId) {
    _pendingIdempotencyKey = null;
    persist(state.items.where((i) => i.productId != productId).toList());
  }

  void updateQuantity(String productId, int quantity) {
    _pendingIdempotencyKey = null;
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updated = state.items
        .map(
          (i) => i.productId == productId ? i.copyWith(quantity: quantity) : i,
        )
        .toList();
    persist(updated);
  }

  void clearCart() {
    _pendingIdempotencyKey = null;
    cartBox.deleteAll(
      cartBox.keys
          .whereType<String>()
          .where((key) => key.startsWith('$userId:'))
          .toList(),
    );
    state = const CartState();
  }

  void persist(List<CartItemModel> items) {
    cartBox.deleteAll(
      cartBox.keys
          .whereType<String>()
          .where((key) => key.startsWith('$userId:'))
          .toList(),
    );
    for (var item in items) {
      cartBox.put(_key(item.productId), item);
    }
    state = state.copyWith(items: items);
  }

  Future<bool> validateWithBackend() async {
    if (state.isEmpty || state.isSyncing) return false;

    state = state.copyWith(isSyncing: true, clearError: true);

    final result = await ref
        .read(checkoutRepositoryProvider)
        .validate(state.items);

    void applySyncResponse(CartValidation data) {
      final syncedMap = {
        for (final item in data.items) item.productId: item,
      };

      final updated = state.items
          .where((item) {
            final synced = syncedMap[item.productId];
            return synced != null && synced.quantity > 0;
          })
          .map((item) {
            final synced = syncedMap[item.productId]!;
            return item.copyWith(
              quantity: synced.quantity,
              priceSnapshot: synced.unitPrice.toDouble(),
            );
          })
          .toList();

      persist(updated);
    }

    switch (result) {
      case ApiSuccess(data: final data):
        applySyncResponse(data);
        state = state.copyWith(
          isSyncing: false,
          syncError: data.messages.isEmpty ? null : data.messages.join('\n'),
          clearError: data.messages.isEmpty,
        );
        return true;
      case ApiFailure(message: final message, statusCode: _):
        state = state.copyWith(isSyncing: false, syncError: message);
        return false;
    }
  }

  Future<ApiResult<CheckoutResult>> checkout(ProfileModel profile) async {
    final valid = await validateWithBackend();
    if (!valid || state.isEmpty) {
      return ApiFailure(state.syncError ?? 'Cart is empty.');
    }
    final random = Random.secure().nextInt(1 << 32);
    final key = _pendingIdempotencyKey ??=
        '${DateTime.now().microsecondsSinceEpoch}-$random';
    final result = await ref
        .read(checkoutRepositoryProvider)
        .checkout(items: state.items, profile: profile, idempotencyKey: key);
    if (result is ApiSuccess<String>) clearCart();
    return result;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final box = Hive.box<CartItemModel>('cartBox');
  final userId = ref.watch(currentUserIdProvider) ?? 'guest';
  return CartNotifier(ref, box, userId);
});
