import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/features/auth/presentation/providers/auth_provider.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() async {
    final prefs = await SharedPreferences.getInstance();
    final authState = ref.watch(authProvider).value;
    final authName = authState is AuthAuthenticated ? authState.username : '';

    return ProfileModel(
      name: authName.isNotEmpty
          ? authName
          : prefs.getString(AppConstants.keyUsername) ?? '',
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

    state = AsyncData(next);
    await ref.read(authProvider.notifier).updateUsername(trimmedName);
  }

  Future<void> saveAddress({
    required String address,
    required String city,
    required String countryRegion,
    required String postcode,
    required String phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final next = (state.value ?? const ProfileModel.empty()).copyWith(
      address: address.trim(),
      city: city.trim(),
      countryRegion: countryRegion.trim(),
      postcode: postcode.trim(),
      phoneNumber: phoneNumber.trim(),
    );

    await prefs.setString(AppConstants.keyDefaultAddress, next.address);
    await prefs.setString(AppConstants.keyAddressCity, next.city);
    await prefs.setString(
      AppConstants.keyAddressCountryRegion,
      next.countryRegion,
    );
    await prefs.setString(AppConstants.keyAddressPostcode, next.postcode);
    await prefs.setString(AppConstants.keyAddressPhoneNumber, next.phoneNumber);

    state = AsyncData(next);
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
