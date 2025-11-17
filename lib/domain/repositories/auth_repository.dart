import 'package:fpdart/fpdart.dart';

import '../../core/core.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, String?>> authenticate({
    required String login,
    required String password,
  });
}
