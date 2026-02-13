import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Dio HTTP Client Configuration
/// Handles all API communication with proper error handling and logging
class DioClient {
  late final Dio _dio;
  // final Logger _logger = Logger();
  
  final void Function()? onUnauthorized;

  DioClient({
    Dio? dio,
    required Future<String?> Function() getAccessToken,
    this.onUnauthorized,
  }) {
    _dio = dio ?? Dio();
    
    // Base Options
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    
    // Request Interceptor (Add Auth Token)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token'; // The Postman collection doesn't always use Bearer but most do.
            // Postman collection uses {{authToken}} in Bearer.
          }
          
          // HIPAA/GDPR Compliance: Do NOT log request data containing PII
          // _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // _logger.d(
          //   'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          // );
          return handler.next(response);
        },
        onError: (error, handler) {
          // _logger.e(
          //   'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          // );
          
          if (error.response?.statusCode == 401) {
            // _logger.w('401 Unauthorized detected - triggering onUnauthorized callback');
            onUnauthorized?.call();
          }
          
          return handler.next(error);
        },
      ),
    );
  }
  
  /// Expose Dio instance for Retrofit
  Dio get dio => _dio;

  /// Handle Dio Errors and convert to custom exceptions
  /// Static so it can be used without instance if needed, or by Repositories
  static AppException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: ErrorMessages.timeout,
          code: error.response?.statusCode,
        );
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        
        if (statusCode == 401) {
          return AuthException(
            message: ErrorMessages.sessionExpired,
            code: statusCode,
          );
        } else if (statusCode == 403) {
          return AuthException(
            message: ErrorMessages.unauthorized,
            code: statusCode,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: ErrorMessages.serverError,
            code: statusCode,
          );
        } else if (statusCode == 400) {
          // Check for validation errors
          if (error.response?.data is Map && error.response?.data['errors'] != null) {
             return ValidationException(
              message: 'Validation failed',
              code: statusCode,
              errors: (error.response?.data['errors'] as List).map((e) {
                if (e is Map && e.containsKey('msg')) {
                  return e['msg'].toString();
                }
                return e.toString();
              }).toList(),
             );
          }
          return ServerException(
            message: error.response?.data?['message'] ?? ErrorMessages.somethingWentWrong,
            code: statusCode,
          );
        } else {
          // Try to extract error message from response
          final message = error.response?.data?['message'] ?? 
                         error.response?.data?['error'] ?? 
                         ErrorMessages.somethingWentWrong;
          return ServerException(
            message: message.toString(),
            code: statusCode,
          );
        }
        
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled',
          code: null,
        );
        
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: ErrorMessages.noInternet,
          code: null,
        );
    }
  }
  
  /// GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
  
  /// POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
  
  /// PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
  
  /// DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
