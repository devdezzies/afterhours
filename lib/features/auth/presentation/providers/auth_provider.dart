import 'package:afterhours/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final String token;
  final String userId; 
  final String username;
  const AuthAuthenticated({
    required this.token, 
    required this.userId, 
    required this.username
  });
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override  
  Future<AuthState> build() async {
    return readFromStorage();
  }

  Future<AuthState> readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.keyAuthToken);
    final userId = prefs.getString(AppConstants.keyUserId);
    final username = prefs.getString(AppConstants.keyUsername);

    if (token != null && token.isNotEmpty && userId != null && userId.isNotEmpty) {
      return AuthAuthenticated(token: token, userId: userId, username: username ?? '');
    } 

    return const AuthUnauthenticated();
  }

  Future<void> setAuthenticated({required String token, required String userId, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAuthToken, token);
    await prefs.setString(AppConstants.keyUserId, userId);
    await prefs.setString(AppConstants.keyUsername, username);

    state = AsyncData(AuthAuthenticated(token: token, userId: userId, username: username));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
    await prefs.remove(AppConstants.keyUserId);
    await prefs.remove(AppConstants.keyUsername); 
    await prefs.remove(AppConstants.keyDefaultAddress);
    await prefs.remove(AppConstants.keyDefaultLat);
    await prefs.remove(AppConstants.keyDefaultLng);

    state = const AsyncData(AuthUnauthenticated());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final isAuthenticatedProvider = Provider<bool>((ref) {
  final auth = ref.watch(authProvider);
  return auth.value is AuthAuthenticated;
});

final currentUserNameProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  final state = auth.value;
  if (state is AuthAuthenticated) {
    return state.username;
  }
  return null;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  final state = auth.value;
  if (state is AuthAuthenticated) {
    return state.userId;
  } 
  return null;
});