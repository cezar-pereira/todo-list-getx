import 'package:dio/dio.dart';

import 'rest_client.dart';
import 'rest_client_response_model.dart';

class DioRestClient implements RestClient {
  final Dio _dio;

  DioRestClient({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(baseUrl != null ? BaseOptions(baseUrl: baseUrl) : null);

  @override
  Future<RestClientResponseModel<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.post<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: finalHeaders),
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestClientResponseModel<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.get<T>(
      url,
      queryParameters: queryParameters,
      options: Options(headers: finalHeaders),
      data: data,
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestClientResponseModel<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.put<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: finalHeaders),
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestClientResponseModel<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.delete<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: finalHeaders),
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestClientResponseModel<T>> patch<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.patch<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: finalHeaders),
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  @override
  Future<RestClientResponseModel<T>> request<T>(
    String url, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    final finalHeaders = Map<String, dynamic>.from(headers ?? {});

    final response = await _dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: method, headers: finalHeaders),
    );

    return RestClientResponseModel<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }
}
