class ProfileModel {
  final String name;
  final String address;
  final String city;
  final String countryRegion;
  final String postcode;
  final String phoneNumber;

  const ProfileModel({
    required this.name,
    required this.address,
    required this.city,
    required this.countryRegion,
    required this.postcode,
    required this.phoneNumber,
  });

  const ProfileModel.empty()
    : name = '',
      address = '',
      city = '',
      countryRegion = '',
      postcode = '',
      phoneNumber = '';

  ProfileModel copyWith({
    String? name,
    String? address,
    String? city,
    String? countryRegion,
    String? postcode,
    String? phoneNumber,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      countryRegion: countryRegion ?? this.countryRegion,
      postcode: postcode ?? this.postcode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
