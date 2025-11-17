import 'app_failure.dart';

class UnhandledFailure extends AppFailure {
  UnhandledFailure([String? message])
    : super(messageError: message ?? 'Erro desconhecido');
}

class ServerFailure extends AppFailure {
  ServerFailure()
    : super(
        messageError:
            'Erro interno no servidor. Tente novamente, se o problema persistir contate o suporte!',
      );
}

class NoNetworkFailure extends AppFailure {
  NoNetworkFailure()
    : super(
        messageError:
            'Por favor, reconecte-se à internet para voltar a usar nosso aplicativo.',
      );
}

class ConnectionTimeoutFailure extends AppFailure {
  ConnectionTimeoutFailure()
    : super(
        messageError:
            'Não foi possível estabelecer uma conexão com o servidor. Por favor, verifique sua conexão com a internet e tente novamente.',
      );
}

class ForbiddenFailure extends AppFailure {
  ForbiddenFailure()
    : super(messageError: 'Você não tem permissão de acesso a este recurso');
}

class BadRequestFailure extends AppFailure {
  BadRequestFailure()
    : super(messageError: 'Requisição inválida. Verifique os dados enviados.');
}

class UnauthorizedFailure extends AppFailure {
  UnauthorizedFailure()
    : super(messageError: 'Você não tem permissão de acesso a este recurso.');
}

class ThirdPartyServicesFailure extends AppFailure {
  ThirdPartyServicesFailure()
    : super(messageError: 'Erro em serviço externo ao sistema.');
}

class InvalidDeviceIdFailure extends AppFailure {
  InvalidDeviceIdFailure()
    : super(
        messageError: 'Seu dispositivo não é permitido para realizar a ação.',
      );
}

class NotAcceptableHereFailure extends AppFailure {
  NotAcceptableHereFailure()
    : super(messageError: 'Solicitação não foi aceita.');
}

class NotFoundFailure extends AppFailure {
  NotFoundFailure()
    : super(messageError: 'O recurso solicitado não foi encontrado.');
}

class ConflictFailure extends AppFailure {
  ConflictFailure()
    : super(
        messageError:
            'Não foi possível atender a solicitação por haver conflitos com os dados enviados.',
      );
}

class TooManyRequestsFailure extends AppFailure {
  TooManyRequestsFailure()
    : super(
        messageError:
            'Você fez muitas requisições. Por favor, tente novamente em instantes.',
      );
}

class CacheFailure extends AppFailure {
  CacheFailure() : super(messageError: 'Erro ao acessar cache local');
}
