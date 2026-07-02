import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/error/failure_handler.dart';

/// HTTP client for API communication
class ApiClient {
  late Dio _dio;

  ApiClient() {
    _setupDio();
  }

  /// Initialize Dio with configuration
  void _setupDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.weatherUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        responseType: ResponseType.json,
      ),
    );

    // Add logging only in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: false,
        ),
      );
    }

    // Add error interceptor
    _dio.interceptors.add(_ErrorInterceptor());
  }

  /// Get request
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);

      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownFailure();
    }
  }

  /// Post request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownFailure();
    }
  }

  /// Handle DioException and convert to Failure
  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutFailure(message: 'Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return NotFoundFailure(message: 'Resource not found');
        } else if (statusCode == 429) {
          return ServerFailure(
            message: 'Too many requests',
            statusCode: statusCode,
          );
        } else if (statusCode! >= 500) {
          return ServerFailure(message: 'Server error', statusCode: statusCode);
        } else {
          return ServerFailure(
            message: e.response?.statusMessage ?? 'Server error',
            statusCode: statusCode,
          );
        }

      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'No internet connection');

      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          return NetworkFailure(message: 'Network error');
        }
        return UnknownFailure(message: e.message ?? 'Unknown error');

      default:
        return UnknownFailure(message: 'Unknown error occurred');
    }
  }
}

/// Custom interceptor for error handling
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
