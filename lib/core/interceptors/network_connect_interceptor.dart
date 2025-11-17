import 'package:dio/dio.dart';

import '../errors/failures.dart';
import '../network/network_info.dart';
import '../services/network_status_service.dart';

class NetworkConnectInterceptor extends Interceptor {
  final NetworkInfo networkInfo;
  final NetworkStatusService networkStatusService;

  NetworkConnectInterceptor({
    required this.networkInfo,
    required this.networkStatusService,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isConnected = await networkInfo.isConnected();

      if (!isConnected) {
        networkStatusService.setOffline();
        return handler.reject(
          DioException(
            requestOptions: options,
            error: NoNetworkFailure(),
            type: DioExceptionType.connectionError,
          ),
        );
      }

      networkStatusService.setOnlineStatus();
      return handler.next(options);
    } catch (e) {
      networkStatusService.setOffline();
      return handler.reject(
        DioException(
          requestOptions: options,
          error: NoNetworkFailure(),
          type: DioExceptionType.connectionError,
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    networkStatusService.setOnlineStatus();
    return handler.next(response);
  }
}
