abstract class AppConstants {
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');
  static const String aiServiceUrl = String.fromEnvironment('AI_SERVICE_URL', defaultValue: 'https://localhost:3345/search');

  static const Duration connectTimeout = Duration(seconds: 15); 
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String cartBox = 'cart';

  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id'; 
  static const String keyUsername = 'user_name';
  static const String keyDefaultAddress = 'default_address'; 
  static const String keyDefaultLat = 'default_lat'; 
  static const String keyDefaultLng = 'default_lng'; 

  static const int pageSize = 20;
  static const int cartItemTypeId = 0;
}

enum ProductCategory {
  peripherals,
  furniture,
  deskAccessories,
  audio,
  eyewear;

  String toApiString() {
    switch (this) {
      case ProductCategory.peripherals:
        return 'peripherals';
      case ProductCategory.furniture:
        return 'furniture';
      case ProductCategory.deskAccessories:
        return 'desk_accessories';
      case ProductCategory.audio:
        return 'audio';
      case ProductCategory.eyewear:
        return 'eyewear';
    }
  }

  static ProductCategory fromString(String value) {
    switch (value) {
      case 'peripherals':
        return ProductCategory.peripherals;
      case 'furniture':
        return ProductCategory.furniture;
      case 'desk_accessories':
        return ProductCategory.deskAccessories;
      case 'audio':
        return ProductCategory.audio;
      case 'eyewear':
        return ProductCategory.eyewear;
      default:
        throw ArgumentError('Unknown category: $value');
    }
  }

  String get displayName {
    switch (this) {
      case ProductCategory.peripherals:
        return 'PERIPHERALS';
      case ProductCategory.furniture:
        return 'FURNITURE';
      case ProductCategory.deskAccessories:
        return 'DESK ACC.';
      case ProductCategory.audio:
        return 'AUDIO';
      case ProductCategory.eyewear:
        return 'EYEWEAR';
    }
  }
}

enum OrderStatus {
  pending,
  shipped,
  delivered;

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        throw ArgumentError('Unknown status: $value');
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.shipped:
        return 'SHIPPED';
      case OrderStatus.delivered:
        return 'DELIVERED';
    }
  }
}