import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/adapters.dart';

class CartState {
  final List<CartItemModel> items; 
  final bool isSyncing;
  final String? syncError; 

  const CartState({
    this.items = const [], 
    this.isSyncing = false, 
    this.syncError
  }); 

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItemModel>? items, 
    bool? isSyncing, 
    String? syncError, 
    bool clearError = false
  }) {
    return CartState(
      items: items ?? this.items, 
      isSyncing: isSyncing ?? this.isSyncing, 
      syncError: clearError ? null : (syncError ?? this.syncError)
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final Box<CartItemModel> cartBox;
  final Ref ref; 

  CartNotifier(this.ref, this.cartBox) : super(CartState(items: cartBox.values.toList()));

  void addItem(CartItemModel newItem) {
    final existingIndex = state.items.indexWhere((i) => i.productId == newItem.productId);

    if (existingIndex >= 0) {
      final updated = List<CartItemModel>.from(state.items);
      updated[existingIndex] = updated[existingIndex].copyWith(quantity: updated[existingIndex].quantity + newItem.quantity);
      persist(updated);
    } else {
      persist([...state.items, newItem]);
    }
  }

  void removeItem(String productId) {
    persist(state.items.where((i) => i.productId != productId).toList()); 
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updated = state.items.map((i) => i.productId == productId ? i.copyWith(quantity: quantity) : i).toList();
    persist(updated);
  }

  void clearCart() {
    cartBox.clear(); 
    state = const CartState();
  }

  void persist(List<CartItemModel> items) {
    cartBox.clear();
    for (var item in items) {
      cartBox.put(item.productId, item);
    }
    state = state.copyWith(items: items);
  }

  Future<void> syncWithBackend() async {
    if (state.isEmpty || state.isSyncing) return;

    state = state.copyWith(isSyncing: true, clearError: true);

    final payload = {
      'items': state.items.map((i) => i.toSyncPayload()).toList(),
    }; 

    final result = await runApiCall(() async {
      final dio = ref.read(dioProvider); 
      final response = await dio.post('/cart/sync', data: payload); 
      return response.data as Map<String, dynamic>;
    });

    void applySyncResponse(Map<String, dynamic> data) {
      final rawItems = data['items'] as List<dynamic>; 
      final syncedMap = {
        for (final e in rawItems) 
          (e as Map<String, dynamic>)['product_id'] as String: e
      };

      final updated = state.items 
        .where((item) {
          final synced = syncedMap[item.productId];
          return synced != null && synced['quantity'] > 0;
        }) 
        .map((item) {
          final synced = syncedMap[item.productId]!; 
          item.quantity = synced['quantity'] as int;  
          return item;
        }).toList();

        persist(updated);
    }

    switch (result) {
      case ApiSuccess(data: final data):
        applySyncResponse(data);
        state = state.copyWith(isSyncing: false);
      case ApiFailure(message: final message, statusCode: _):
        state = state.copyWith(isSyncing: false, syncError: message);
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final box = Hive.box<CartItemModel>('cartBox');
  return CartNotifier(ref, box);
});
