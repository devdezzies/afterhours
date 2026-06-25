abstract class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://afterhours-backend-u5ha.onrender.com/api',
  );
  static const String currencyPrefix = 'RP';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String cartBox = 'cart';

  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'user_name';
  static const String keyDefaultAddress = 'default_address';
  static const String keyDefaultLat = 'default_lat';
  static const String keyDefaultLng = 'default_lng';
  static const String keyAddressCity = 'profile_address_city';
  static const String keyAddressCountryRegion =
      'profile_address_country_region';
  static const String keyAddressPostcode = 'profile_address_postcode';
  static const String keyAddressPhoneNumber = 'profile_address_phone_number';

  static const int pageSize = 20;
  static const int backendMaxPageSize = 50;
  static const int cartItemTypeId = 0;
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Unknown status: $value');
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.processing:
        return 'PROCESSING';
      case OrderStatus.shipped:
        return 'SHIPPED';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }
}
