import 'package:dio/dio.dart';

import '../storage_services/local_stoage_service.dart';

class NetworkService {
  late final Dio _dio;

  // Singleton pattern
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  NetworkService._internal() {
    _dio = Dio();
    _initializeDio();
  }

  /// Call this right after you get your token from the login API
  Future<void> setLoginToken(String? token) async {
    // also immediately apply it to Dio so you don't have to wait for next request
    _dio.options.headers['Authorization'] = '$token';
  }

  /// Initialize Dio with base configuration
  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://app.superinstajobs.com/api/v1/',
      // Replace with your API base URL
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 90),
     /* headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },*/
    );

    // Add interceptors for logging, authentication, etc.
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    // Authentication interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final needsToken = options.extra['requiresAuth'] ?? true;
          if (needsToken) {
            print(_getAuthToken());
            final token = _getAuthToken();
            if (token != null) {
              options.headers['Authorization'] =  token;
            }
          }
          /* // Get token from secure storage
          final token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }*/
          return handler.next(options);
        },
      ),
    );
  }

  /// Get authentication token from secure storage
  String? _getAuthToken() {
    String? token = StorageService().getUserData().authToken;
    return token;
  }

  /// Update base URL (useful for different environments)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Add custom headers
  void addHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Generic request method
  Future<ApiResponse<T>> _request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
    T Function(Map<String, dynamic>)? converter,
    bool requiresAuth = true,
  }) async {
    try {
      final options = Options(
        method: method.value,
        headers: headers,
        extra: {'requiresAuth': requiresAuth},
        responseType: responseType,
      );

      final Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, converter);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse<T>.error(
        message: 'Unexpected error occurred: ${e.toString()}',
        statusCode: 0,
        rawError: e,
      );
    }
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? converter,
  ) {
    try {
      final responseData = response.data;

      // Check if this is an API error wrapped in a 200 response
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('status') &&
          responseData['status'] == false) {
        // This is an error response with 200 status code
        return _parseErrorResponse<T>(responseData, response.statusCode!);
      }

      // This is a genuine success response
      if (converter != null) {
        // Only apply converter if response data is a Map
        if (responseData is Map<String, dynamic>) {
          final T convertedData = converter(responseData);
          return ApiResponse<T>.success(
            data: convertedData,
            statusCode: response.statusCode!,
            rawResponse: responseData,
          );
        } else {
          // Handle case where responseData is not a Map but the converter expects one
          return ApiResponse<T>.error(
            message: 'Invalid response format. Expected a JSON object.',
            statusCode: response.statusCode!,
            rawResponse: responseData,
          );
        }
      } else {
        // No converter provided, return as is
        return ApiResponse<T>.success(
          data: responseData as T,
          statusCode: response.statusCode!,
          rawResponse: responseData,
        );
      }
    } catch (e) {
      // Error during response parsing
      return ApiResponse<T>.error(
        message: 'Error parsing response: ${e.toString()}',
        statusCode: response.statusCode!,
        rawResponse: response.data,
        rawError: e,
      );
    }
  }

  /// Parse error response with your specific API error structure
  ApiResponse<T> _parseErrorResponse<T>(
    Map<String, dynamic> errorData,
    int statusCode,
  ) {
    print(errorData);
    String errorMessage = 'Unknown error occurred';


    // Extract error message from the top level
    if (errorData.containsKey('errorMessage')) {
      errorMessage = errorData['errorMessage'].toString();
    }

    // Check for nested error messages in your specific structure
    if (errorData.containsKey('result') &&
        errorData['result'] is Map &&
        errorData['result'].containsKey('response') &&
        errorData['result']['response'] is Map) {
      var responseData = errorData['result']['response'];

      // Extract nested messages
      if (responseData.containsKey('errorMessage')) {
        var nestedMessages = responseData['errorMessage'];


      }
    }

    return ApiResponse<T>.error(
      message: errorMessage,

      statusCode: errorData['statusCode'] ?? statusCode,
      rawResponse: errorData,
    );
  }

  /// Handle Dio errors
  ApiResponse<T> _handleDioError<T>(DioException e) {
    // Try to parse the error response if available
    if (e.response != null && e.response!.data is Map<String, dynamic>) {
      return _parseErrorResponse<T>(
        e.response!.data,
        e.response!.statusCode ?? 0,
      );
    }

    // Handle connection errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
          rawError: e,
        );

      case DioExceptionType.badCertificate:
        return ApiResponse<T>.error(
          message: 'Invalid SSL certificate.',
          statusCode: 495,
          rawError: e,
        );

      case DioExceptionType.badResponse:
        return ApiResponse<T>.error(
          message: 'Server error. Please try again later.',
          statusCode: e.response?.statusCode ?? 0,
          rawResponse: e.response?.data,
          rawError: e,
        );

      case DioExceptionType.cancel:
        return ApiResponse<T>.error(
          message: 'Request was cancelled.',
          statusCode: 499,
          rawError: e,
        );

      case DioExceptionType.connectionError:
        return ApiResponse<T>.error(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
          rawError: e,
        );

      default:
        return ApiResponse<T>.error(
          message: 'Unexpected error occurred: ${e.message}',
          statusCode: 0,
          rawError: e,
        );
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>({
    required String path,
    bool requiresAuth = true,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? converter,
  }) async {
    return _request<T>(
      path: path,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      headers: headers,
      converter: converter,
    );
  }

  /// POST FORM DATA
  /// POST request with FormData
  Future<ApiResponse<T>> postFormData<T>({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) converter,
  }) async {
    final formData = FormData.fromMap(data);
print(formData.fields);
print(data);
    return _request<T>(
      path: path,
      method: HttpMethod.post,
      data: formData,
      queryParameters: queryParameters,
      headers: {
        'Content-Type': 'multipart/form-data',
        ...?headers,
      },
      converter: converter,
    );
  }



  /// POST request
  Future<ApiResponse<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? converter,
  }) async {
    return _request<T>(
      path: path,
      method: HttpMethod.post,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      converter: converter,
    );
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? converter,
  }) async {
    return _request<T>(
      path: path,
      method: HttpMethod.put,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      converter: converter,
    );
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? converter,
  }) async {
    return _request<T>(
      path: path,
      method: HttpMethod.patch,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      converter: converter,
    );
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? converter,
  }) async {
    return _request<T>(
      path: path,
      method: HttpMethod.delete,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      converter: converter,
    );
  }
}

/// HTTP methods enum
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  const HttpMethod(this.value);

  final String value;
}

/// API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final List<String> detailedMessages;
  final int statusCode;
  final dynamic rawError;
  final ResponseStatus status;
  final dynamic rawResponse;

  ApiResponse._({
    this.data,
    this.message,
    this.detailedMessages = const [],
    required this.statusCode,
    this.rawError,
    required this.status,
    this.rawResponse,
  });

  factory ApiResponse.success({
    required T? data,
    required int statusCode,
    String? message,
    dynamic rawResponse,
  }) {
    return ApiResponse._(
      data: data,
      statusCode: statusCode,
      message: message,
      status: ResponseStatus.success,
      rawResponse: rawResponse,
    );
  }

  factory ApiResponse.error({
    dynamic data,
    required String message,

    required int statusCode,
    dynamic rawError,
    dynamic rawResponse,
  }) {
    return ApiResponse._(
      data: data as T?,
      message: message,

      statusCode: statusCode,
      rawError: rawError,
      status: ResponseStatus.error,
      rawResponse: rawResponse,
    );
  }

  bool get isSuccess => status == ResponseStatus.success;

  bool get isError => status == ResponseStatus.error;

  /// Get all error messages including both the main message and detailed messages
}

/// Response status enum
enum ResponseStatus { success, error }
