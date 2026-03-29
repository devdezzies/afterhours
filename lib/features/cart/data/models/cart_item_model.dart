import 'package:afterhours/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: AppConstants.cartItemTypeId)
class CartItemModel extends HiveObject {
  @HiveField(0) 
  final String productId; 

  @HiveField(1) 
  final String productName;

  @HiveField(2) 
  final double priceSnapshot;

  @HiveField(3) 
  int quantity;

  @HiveField(4)
  final String imageUrl; 

  @HiveField(5) 
  final String category;

  CartItemModel({
    required this.productId, 
    required this.productName, 
    required this.priceSnapshot, 
    required this.quantity,
    required this.imageUrl, 
    required this.category
  });

  double get lineTotal => priceSnapshot * quantity; 

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(productId: productId, productName: productName, priceSnapshot: priceSnapshot, quantity: quantity ?? this.quantity, imageUrl: imageUrl, category: category); 
  }

  Map<String, dynamic> toSyncPayload() => {
    'product_id': productId,
    'quantity': quantity    
  };


} 