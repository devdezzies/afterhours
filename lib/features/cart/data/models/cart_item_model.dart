import 'package:afterhours/core/constants/app_constants.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: AppConstants.cartItemTypeId)
class CartItemModel extends HiveObject {
  @HiveField(0, defaultValue: '')
  final String productId;

  @HiveField(1, defaultValue: 'Unknown product')
  final String productName;

  @HiveField(2, defaultValue: 0.0)
  final double priceSnapshot;

  @HiveField(3, defaultValue: 1)
  int quantity;

  @HiveField(4, defaultValue: '')
  final String imageUrl;

  @HiveField(5, defaultValue: '')
  final String category;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.priceSnapshot,
    required this.quantity,
    this.imageUrl = '',
    this.category = '',
  });

  double get lineTotal => priceSnapshot * quantity;

  CartItemModel copyWith({int? quantity, double? priceSnapshot}) {
    return CartItemModel(
      productId: productId,
      productName: productName,
      priceSnapshot: priceSnapshot ?? this.priceSnapshot,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      category: category,
    );
  }

  Map<String, dynamic> toSyncPayload() => {
    'product_id': productId,
    'quantity': quantity,
  };
}
