import 'package:dio/dio.dart';

import '../errors/app_failure.dart';

class FailureInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = AppFailure.fromDioError(err);

    handler.reject(failure);
  }
}
