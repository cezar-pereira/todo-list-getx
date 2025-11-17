import 'rest_client_response_model.dart';

abstract class RestClient {
  Future<RestClientResponseModel<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  });

  Future<RestClientResponseModel<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
    String? token,
  });

  Future<RestClientResponseModel<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  });

  Future<RestClientResponseModel<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  });

  Future<RestClientResponseModel<T>> patch<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  });

  Future<RestClientResponseModel<T>> request<T>(
    String url, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
  });
}
