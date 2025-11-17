import 'package:dio/dio.dart';

import '../services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;

  AuthInterceptor({required this.tokenService});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
