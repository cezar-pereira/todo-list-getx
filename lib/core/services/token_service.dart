import 'storage_service.dart';

abstract class TokenService {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<bool> hasToken();
}

class TokenServiceImpl implements TokenService {
  final StorageService storageService;

  TokenServiceImpl({required this.storageService});

  @override
  Future<String?> getToken() async {
    return await storageService.getString(StorageService.tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await storageService.setString(StorageService.tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await storageService.remove(StorageService.tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
