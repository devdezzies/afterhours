class ProfileModel {
  final String name;
  final String email;
  final String address;
  final String city;
  final String countryRegion;
  final String postcode;
  final String phoneNumber;
  final double? latitude;
  final double? longitude;

  const ProfileModel({
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.countryRegion,
    required this.postcode,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
  });

  const ProfileModel.empty()
    : name = '',
      email = '',
      address = '',
      city = '',
      countryRegion = '',
      postcode = '',
      phoneNumber = '',
      latitude = null,
      longitude = null;

  ProfileModel copyWith({
    String? name,
    String? email,
    String? address,
    String? city,
    String? countryRegion,
    String? postcode,
    String? phoneNumber,
    double? latitude,
    double? longitude,
    bool clearLatitude = false,
    bool clearLongitude = false,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      countryRegion: countryRegion ?? this.countryRegion,
      postcode: postcode ?? this.postcode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: clearLatitude ? null : latitude ?? this.latitude,
      longitude: clearLongitude ? null : longitude ?? this.longitude,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final address = json['default_address'] is Map<String, dynamic>
        ? json['default_address'] as Map<String, dynamic>
        : const <String, dynamic>{};
    return ProfileModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: address['address']?.toString() ?? '',
      city: address['city']?.toString() ?? '',
      countryRegion: address['country_region']?.toString() ?? '',
      postcode: address['postcode']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      latitude: (address['latitude'] as num?)?.toDouble(),
      longitude: (address['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final hasCompleteAddress =
        address.isNotEmpty &&
        city.isNotEmpty &&
        countryRegion.isNotEmpty &&
        postcode.isNotEmpty;
    return {
      'name': name,
      'phone_number': phoneNumber,
      if (hasCompleteAddress)
        'default_address': {
          'address': address,
          'city': city,
          'country_region': countryRegion,
          'postcode': postcode,
          'latitude': latitude,
          'longitude': longitude,
        },
    };
  }
}
