import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:afterhours/features/profile/data/repositories/profile_repository.dart';
import 'package:afterhours/core/utils/api_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() async {
    final prefs = await SharedPreferences.getInstance();
    final authState = ref.watch(authProvider).value;
    final authName = authState is AuthAuthenticated ? authState.username : '';

    if (authState is AuthAuthenticated) {
      final result = await ref.read(profileRepositoryProvider).getProfile();
      if (result case ApiSuccess(:final data)) {
        await _cache(data);
        return data;
      }
    }

    return ProfileModel(
      name: authName.isNotEmpty
          ? authName
          : prefs.getString(AppConstants.keyUsername) ?? '',
      email: '',
      address: prefs.getString(AppConstants.keyDefaultAddress) ?? '',
      city: prefs.getString(AppConstants.keyAddressCity) ?? '',
      countryRegion:
          prefs.getString(AppConstants.keyAddressCountryRegion) ?? '',
      postcode: prefs.getString(AppConstants.keyAddressPostcode) ?? '',
      phoneNumber: prefs.getString(AppConstants.keyAddressPhoneNumber) ?? '',
    );
  }

  Future<void> saveName(String name) async {
    final trimmedName = name.trim();
    final current = state.value ?? const ProfileModel.empty();
    final next = current.copyWith(name: trimmedName);

    await _saveRemote(next);
  }

  Future<void> saveAddress({
    required String address,
    required String city,
    required String countryRegion,
    required String postcode,
    required String phoneNumber,
  }) async {
    final next = (state.value ?? const ProfileModel.empty()).copyWith(
      address: address.trim(),
      city: city.trim(),
      countryRegion: countryRegion.trim(),
      postcode: postcode.trim(),
      phoneNumber: phoneNumber.trim(),
    );

    await _saveRemote(next);
  }

  Future<void> _saveRemote(ProfileModel next) async {
    final result = await ref.read(profileRepositoryProvider).updateProfile(next);
    switch (result) {
      case ApiSuccess(:final data):
        await _cache(data);
        await ref.read(authProvider.notifier).updateUsername(data.name);
        state = AsyncData(data);
      case ApiFailure(:final message):
        throw Exception(message);
    }
  }

  Future<void> _cache(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUsername, profile.name);
    await prefs.setString(AppConstants.keyDefaultAddress, profile.address);
    await prefs.setString(AppConstants.keyAddressCity, profile.city);
    await prefs.setString(
      AppConstants.keyAddressCountryRegion,
      profile.countryRegion,
    );
    await prefs.setString(AppConstants.keyAddressPostcode, profile.postcode);
    await prefs.setString(
      AppConstants.keyAddressPhoneNumber,
      profile.phoneNumber,
    );
  }
}

final profileProvider = AsyncNotifierProvider<ProfileController, ProfileModel>(
  ProfileController.new,
);

final profileDisplayNameProvider = Provider<String>((ref) {
  final profile = ref.watch(profileProvider).value;
  final name = profile?.name.trim() ?? '';
  return name.isNotEmpty ? name.split(' ').first.toUpperCase() : 'USER';
});
