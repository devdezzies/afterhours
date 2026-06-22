import 'package:afterhours/core/constants/app_constants.dart';
import 'package:afterhours/core/utils/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef LogoutCallback = Future<void> Function();
LogoutCallback? on401Logout;

void configureDio401Handler(LogoutCallback logoutCallback) {
  on401Logout = logoutCallback;
}

class AuthInterceptor extends Interceptor {
  @override  
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override 
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && on401Logout != null) {
      Future.microtask(() => on401Logout!());
    }
    handler.next(err);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl, 
      connectTimeout: AppConstants.connectTimeout, 
      receiveTimeout: AppConstants.receiveTimeout, 
      headers: {
        'Accept': 'application/json', 
        'Content-Type': 'application/json'
      }
    )
  );

  dio.interceptors.add(AuthInterceptor());

  assert(() {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    return true;
  }());

  return dio;
});
