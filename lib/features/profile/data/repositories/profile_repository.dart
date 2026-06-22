import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:afterhours/features/profile/data/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRepository {
  final Ref ref;
  const ProfileRepository(this.ref);

  Future<ApiResult<ProfileModel>> getProfile() => runApiCall(() async {
    final response = await ref.read(dioProvider).get('/profile');
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  });

  Future<ApiResult<ProfileModel>> updateProfile(ProfileModel profile) =>
      runApiCall(() async {
        final response = await ref
            .read(dioProvider)
            .put('/profile', data: profile.toJson());
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      });
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  ProfileRepository.new,
);
