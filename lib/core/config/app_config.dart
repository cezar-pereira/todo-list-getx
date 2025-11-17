class AppConfig {
  // URLs
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://lf.infornet.com.br:3010/',
  );

  // Credenciais de Autenticação
  static const String authLogin = String.fromEnvironment(
    'AUTH_LOGIN',
    defaultValue: 'testeFlutter',
  );

  static const String authPassword = String.fromEnvironment(
    'AUTH_PASSWORD',
    defaultValue: '#Qsy&_@73bh',
  );

  // Timeouts (em segundos)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
}
