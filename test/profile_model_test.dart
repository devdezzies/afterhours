import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses and serializes the backend profile contract', () {
    final profile = ProfileModel.fromJson({
      'name': 'Customer One',
      'email': 'customer@example.com',
      'phone_number': '08123456789',
      'default_address': {
        'address': 'Jalan Satu',
        'city': 'Jakarta',
        'country_region': 'Indonesia',
        'postcode': '12345',
        'latitude': -6.2,
        'longitude': 106.8,
      },
    });

    expect(profile.name, 'Customer One');
    expect(profile.city, 'Jakarta');
    expect(profile.latitude, -6.2);
    expect(profile.longitude, 106.8);

    expect(profile.toJson(), {
      'name': 'Customer One',
      'phone_number': '08123456789',
      'default_address': {
        'address': 'Jalan Satu',
        'city': 'Jakarta',
        'country_region': 'Indonesia',
        'postcode': '12345',
        'latitude': -6.2,
        'longitude': 106.8,
      },
    });
  });
}
