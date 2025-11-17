import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/core/core.dart';

void main() {
  late FailureInterceptor interceptor;

  setUp(() {
    interceptor = FailureInterceptor();
  });

  group('FailureInterceptor', () {
    test('deve converter DioException.connectionError em NoNetworkFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
        error: 'Connection error',
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<NoNetworkFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Por favor, reconecte-se à internet para voltar a usar nosso aplicativo.',
      );
    });

    test(
      'deve converter DioException.connectionTimeout em ConnectionTimeoutFailure',
      () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
          error: 'Connection timeout',
        );

        var interceptedFailure = dioError;
        final handler = _MockErrorInterceptorHandler((failure) {
          interceptedFailure = failure;
        });

        // Act
        interceptor.onError(dioError, handler);

        // Assert
        expect(interceptedFailure, isA<ConnectionTimeoutFailure>());
        expect(
          (interceptedFailure as AppFailure).messageError,
          'Não foi possível estabelecer uma conexão com o servidor. Por favor, verifique sua conexão com a internet e tente novamente.',
        );
      },
    );

    test(
      'deve converter DioException.receiveTimeout em ConnectionTimeoutFailure',
      () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
          error: 'Receive timeout',
        );

        var interceptedFailure = dioError;
        final handler = _MockErrorInterceptorHandler((failure) {
          interceptedFailure = failure;
        });

        // Act
        interceptor.onError(dioError, handler);

        // Assert
        expect(interceptedFailure, isA<ConnectionTimeoutFailure>());
      },
    );

    test(
      'deve converter DioException.sendTimeout em ConnectionTimeoutFailure',
      () {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.sendTimeout,
          error: 'Send timeout',
        );

        var interceptedFailure = dioError;
        final handler = _MockErrorInterceptorHandler((failure) {
          interceptedFailure = failure;
        });

        // Act
        interceptor.onError(dioError, handler);

        // Assert
        expect(interceptedFailure, isA<ConnectionTimeoutFailure>());
      },
    );

    test('deve converter status code 400 em BadRequestFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<BadRequestFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Requisição inválida. Verifique os dados enviados.',
      );
    });

    test('deve converter status code 401 em UnauthorizedFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<UnauthorizedFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Você não tem permissão de acesso a este recurso.',
      );
    });

    test('deve converter status code 403 em ForbiddenFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ForbiddenFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Você não tem permissão de acesso a este recurso',
      );
    });

    test('deve converter status code 404 em NotFoundFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<NotFoundFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'O recurso solicitado não foi encontrado.',
      );
    });

    test('deve converter status code 500 em ServerFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ServerFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Erro interno no servidor. Tente novamente, se o problema persistir contate o suporte!',
      );
    });

    test('deve converter status code 502 em ServerFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 502,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ServerFailure>());
    });

    test('deve converter status code 503 em ServerFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 503,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ServerFailure>());
    });

    test('deve converter status code desconhecido em UnhandledFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 418, // I'm a teapot
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<UnhandledFailure>());
    });

    test('deve converter status code null em UnhandledFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: null,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<UnhandledFailure>());
    });

    test('deve converter status code 409 em ConflictFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 409,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ConflictFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Não foi possível atender a solicitação por haver conflitos com os dados enviados.',
      );
    });

    test('deve converter status code 481 em InvalidDeviceIdFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 481,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<InvalidDeviceIdFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Seu dispositivo não é permitido para realizar a ação.',
      );
    });

    test('deve converter status code 485 em ThirdPartyServicesFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 485,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<ThirdPartyServicesFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Erro em serviço externo ao sistema.',
      );
    });

    test('deve converter status code 488 em NotAcceptableHereFailure', () {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 488,
        ),
      );

      var interceptedFailure = dioError;
      final handler = _MockErrorInterceptorHandler((failure) {
        interceptedFailure = failure;
      });

      // Act
      interceptor.onError(dioError, handler);

      // Assert
      expect(interceptedFailure, isA<NotAcceptableHereFailure>());
      expect(
        (interceptedFailure as AppFailure).messageError,
        'Solicitação não foi aceita.',
      );
    });
  });
}

class _MockErrorInterceptorHandler extends ErrorInterceptorHandler {
  final void Function(DioException) onRejectCallback;

  _MockErrorInterceptorHandler(this.onRejectCallback);

  @override
  void reject(DioException error, [ErrorInterceptorHandler? handler]) {
    onRejectCallback(error);
  }
}
