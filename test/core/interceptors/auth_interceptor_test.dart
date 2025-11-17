import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todolist/core/core.dart';

class MockTokenService extends Mock implements TokenService {}

void main() {
  group('AuthInterceptor', () {
    test('deve adicionar header Authorization quando token não é null', () async {
      // Arrange
      const token = 'valid_token_123';
      final mockTokenService = MockTokenService();
      when(() => mockTokenService.getToken()).thenAnswer((_) async => token);

      final interceptor = AuthInterceptor(tokenService: mockTokenService);
      final requestOptions = RequestOptions(path: '/test');
      var interceptedOptions = requestOptions;

      final handler = _MockRequestInterceptorHandler((options) {
        interceptedOptions = options;
      });

      // Act
      interceptor.onRequest(requestOptions, handler);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(interceptedOptions.headers['Authorization'], 'Bearer $token');
      expect(interceptedOptions.headers.containsKey('Authorization'), true);
    });

    test('não deve adicionar header Authorization quando token é null', () async {
      // Arrange
      final mockTokenService = MockTokenService();
      when(() => mockTokenService.getToken()).thenAnswer((_) async => null);

      final interceptor = AuthInterceptor(tokenService: mockTokenService);
      final requestOptions = RequestOptions(path: '/test');
      var interceptedOptions = requestOptions;

      final handler = _MockRequestInterceptorHandler((options) {
        interceptedOptions = options;
      });

      // Act
      interceptor.onRequest(requestOptions, handler);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(interceptedOptions.headers.containsKey('Authorization'), false);
    });

    test('não deve sobrescrever headers existentes', () async {
      // Arrange
      const token = 'valid_token_123';
      final mockTokenService = MockTokenService();
      when(() => mockTokenService.getToken()).thenAnswer((_) async => token);

      final interceptor = AuthInterceptor(tokenService: mockTokenService);
      final requestOptions = RequestOptions(
        path: '/test',
        headers: {'Content-Type': 'application/json'},
      );
      var interceptedOptions = requestOptions;

      final handler = _MockRequestInterceptorHandler((options) {
        interceptedOptions = options;
      });

      // Act
      interceptor.onRequest(requestOptions, handler);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(interceptedOptions.headers['Authorization'], 'Bearer $token');
      expect(interceptedOptions.headers['Content-Type'], 'application/json');
      expect(interceptedOptions.headers.length, 2);
    });

    test('deve adicionar header Authorization com formato Bearer correto', () async {
      // Arrange
      const token = 'my_secret_token';
      final mockTokenService = MockTokenService();
      when(() => mockTokenService.getToken()).thenAnswer((_) async => token);

      final interceptor = AuthInterceptor(tokenService: mockTokenService);
      final requestOptions = RequestOptions(path: '/test');
      var interceptedOptions = requestOptions;

      final handler = _MockRequestInterceptorHandler((options) {
        interceptedOptions = options;
      });

      // Act
      interceptor.onRequest(requestOptions, handler);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(interceptedOptions.headers['Authorization'], 'Bearer $token');
      expect(
        interceptedOptions.headers['Authorization']?.startsWith('Bearer '),
        true,
      );
    });

    test('não deve adicionar header quando token é vazio', () async {
      // Arrange
      const token = '';
      final mockTokenService = MockTokenService();
      when(() => mockTokenService.getToken()).thenAnswer((_) async => token);

      final interceptor = AuthInterceptor(tokenService: mockTokenService);
      final requestOptions = RequestOptions(path: '/test');
      var interceptedOptions = requestOptions;

      final handler = _MockRequestInterceptorHandler((options) {
        interceptedOptions = options;
      });

      // Act
      interceptor.onRequest(requestOptions, handler);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(interceptedOptions.headers.containsKey('Authorization'), false);
    });
  });
}

class _MockRequestInterceptorHandler extends RequestInterceptorHandler {
  final void Function(RequestOptions) onNextCallback;

  _MockRequestInterceptorHandler(this.onNextCallback);

  @override
  void next(RequestOptions requestOptions) {
    onNextCallback(requestOptions);
  }
}
