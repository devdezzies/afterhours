import 'package:dio/dio.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data; 
  const ApiSuccess(this.data);
}

final class ApiFailure extends ApiResult<Never> {
  final String message; 
  final int? statusCode;

  const ApiFailure(this.message, {this.statusCode});
}

Future<ApiResult<T>> runApiCall<T>(Future<T> Function() call) async {
  try {
    final data = await call();
    return ApiSuccess(data);
  } on DioException catch (e) {
    final message = parseDioError(e);
    return ApiFailure(message, statusCode: e.response?.statusCode);
  } catch (e) {
    return ApiFailure(e.toString());
  }
}

String parseDioError(DioException e) {
  if (e.response?.data is Map) {
    final data = e.response!.data as Map;
    return data['message']?.toString() ?? e.message ?? 'Unknown error';
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out. Check your network connection.';
    case DioExceptionType.connectionError:
      return 'No connection. Are you offline?';
    default:
      return e.message ?? 'Something went wrong.';
  }
}