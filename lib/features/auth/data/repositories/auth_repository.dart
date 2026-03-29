import 'package:afterhours/core/utils/api_result.dart';
import 'package:afterhours/core/utils/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginResponse {
  final String token; 
  final String userId; 
  final String username; 
  final String email; 

  const LoginResponse({
    required this.token, 
    required this.userId, 
    required this.username, 
    required this.email
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return LoginResponse(
      token: json['token'], 
      userId: user['user_id'], 
      username: user['username'] ?? '', 
      email: user['email'] ?? ''
    );
  }
}

class AuthRepository {
  final Ref ref; 
  const AuthRepository(this.ref); 

  Future<ApiResult<LoginResponse>> login({required String email, required String password}) async {
    return runApiCall(() async {
      final dio = ref.read(dioProvider); 
      final response = await dio.post('/auth/login', data: {
        'email': email, 
        'password': password  
      });
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<LoginResponse>> register({required String username, required String email, required String password}) async {
    return runApiCall(() async {
      final dio = ref.read(dioProvider); 
      final response = await dio.post('/auth/register', data: {
        'username': username, 
        'email': email, 
        'password': password  
      });
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<void>> logout() async {
    return runApiCall(() async {
      final dio = ref.read(dioProvider);
      await dio.post('/auth/logout');
    });
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));