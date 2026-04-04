import 'package:afterhours/core/constants/app_constants.dart';

class ProductModel {
  final String id; 
  final String name; 
  final String description;
  final double price; 
  final int stock; 
  final ProductCategory category; 
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      category: ProductCategory.fromString(json['category'] as String),
      imageUrl: json['image_url'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category.toApiString(),
      'image_url': imageUrl
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    ProductCategory? category,
    String? imageUrl
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is ProductModel && runtimeType == other.runtimeType && id == other.id);
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class PaginatedProducts {
  final List<ProductModel> products;
  final int currentPage;
  final int lastPage;

  const PaginatedProducts({
    required this.products,
    required this.currentPage,
    required this.lastPage
  });

  bool get hasMore => currentPage < lastPage;

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>;
    return PaginatedProducts(
      products: rawList.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int
    );
  }
}