import 'package:dio/dio.dart';

import 'failures.dart';

class AppFailure extends DioException {
  final String messageError;
  final String? titleError;

  AppFailure({
    required this.messageError,
    this.titleError,
    DioException? dioError,
  }) : super(
         requestOptions: dioError?.requestOptions ?? RequestOptions(path: ''),
         response: dioError?.response,
         type: dioError?.type ?? DioExceptionType.unknown,
         error: dioError?.error,
         message: messageError,
       );

  static AppFailure fromDioError(DioException dioError) {
    if (dioError.type == DioExceptionType.connectionError) {
      return NoNetworkFailure();
    }

    if (dioError.type == DioExceptionType.receiveTimeout ||
        dioError.type == DioExceptionType.sendTimeout ||
        dioError.type == DioExceptionType.connectionTimeout) {
      return ConnectionTimeoutFailure();
    }

    return _handleStatusCode(dioError.response?.statusCode);
  }
}

AppFailure _handleStatusCode(int? statusCode) {
  return switch (statusCode) {
    400 => BadRequestFailure(),
    401 => UnauthorizedFailure(),
    402 => BadRequestFailure(),
    403 => ForbiddenFailure(),
    404 => NotFoundFailure(),
    409 => ConflictFailure(),
    481 => InvalidDeviceIdFailure(),
    485 => ThirdPartyServicesFailure(),
    488 => NotAcceptableHereFailure(),
    500 => ServerFailure(),
    502 => ServerFailure(),
    503 => ServerFailure(),
    _ => UnhandledFailure(),
  };
}
