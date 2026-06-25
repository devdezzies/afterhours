import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:afterhours/features/profile/data/repositories/profile_repository.dart';
import 'package:afterhours/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProfileRepository implements ProfileRepository {
  ProfileModel? updatedProfile;

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<ApiResult<ProfileModel>> getProfile() async {
    return const ApiSuccess(ProfileModel.empty());
  }

  @override
  Future<ApiResult<ProfileModel>> updateProfile(ProfileModel profile) async {
    updatedProfile = profile;
    return ApiSuccess(profile);
  }
}

void main() {
  test('saveAddress sends selected map coordinates', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final fakeRepository = FakeProfileRepository();
    final container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);

    await container
        .read(profileProvider.notifier)
        .saveAddress(
          address: ' Jalan Satu ',
          city: ' Jakarta ',
          countryRegion: ' Indonesia ',
          postcode: ' 12345 ',
          phoneNumber: ' 0812 ',
          latitude: -6.2,
          longitude: 106.8,
        );

    expect(fakeRepository.updatedProfile?.address, 'Jalan Satu');
    expect(fakeRepository.updatedProfile?.latitude, -6.2);
    expect(fakeRepository.updatedProfile?.longitude, 106.8);
  });

  test('saveAddress allows missing map coordinates', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final fakeRepository = FakeProfileRepository();
    final container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(fakeRepository)],
    );
    addTearDown(container.dispose);

    await container
        .read(profileProvider.notifier)
        .saveAddress(
          address: 'Jalan Satu',
          city: 'Jakarta',
          countryRegion: 'Indonesia',
          postcode: '12345',
          phoneNumber: '0812',
        );

    expect(fakeRepository.updatedProfile?.latitude, isNull);
    expect(fakeRepository.updatedProfile?.longitude, isNull);
  });
}
