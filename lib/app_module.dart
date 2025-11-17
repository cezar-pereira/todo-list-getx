import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'core/core.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/todo_local_datasource.dart';
import 'data/datasources/todo_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/get_todos_usecase.dart';
import 'presentation/controllers/todo_controller.dart';

class AppModule extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<StorageService>(StorageServiceImpl());
    Get.put<TokenService>(
      TokenServiceImpl(storageService: Get.find<StorageService>()),
    );
    Get.put<Connectivity>(Connectivity());
    Get.put<NetworkInfo>(NetworkInfoImpl(Get.find<Connectivity>()));
    Get.put<NetworkStatusService>(NetworkStatusService());

    // RestClient with Interceptors
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(seconds: AppConfig.connectTimeout),
        receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
        sendTimeout: Duration(seconds: AppConfig.sendTimeout),
      ),
    );
    dio.interceptors.addAll([
      NetworkConnectInterceptor(
        networkInfo: Get.find<NetworkInfo>(),
        networkStatusService: Get.find<NetworkStatusService>(),
      ),
      AuthInterceptor(tokenService: Get.find<TokenService>()),
      FailureInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: false,
        ),
    ]);
    Get.put<RestClient>(DioRestClient(dio: dio));

    // DataSources
    Get.put<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(restClient: Get.find<RestClient>()),
    );
    Get.put<TodoRemoteDataSource>(
      TodoRemoteDataSourceImpl(restClient: Get.find<RestClient>()),
    );
    Get.put<TodoLocalDataSource>(
      TodoLocalDataSourceImpl(Get.find<StorageService>()),
    );

    // Repositories
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        tokenService: Get.find<TokenService>(),
      ),
    );
    Get.put<TodoRepository>(
      TodoRepositoryImpl(
        remoteDataSource: Get.find<TodoRemoteDataSource>(),
        localDataSource: Get.find<TodoLocalDataSource>(),
      ),
    );

    // UseCases
    Get.put<IGetTodosUseCase>(GetTodosUseCase(Get.find<TodoRepository>()));

    // Controllers
    Get.put<TodoController>(
      TodoController(
        getTodosUseCase: Get.find<IGetTodosUseCase>(),
        authRepository: Get.find<AuthRepository>(),
        networkStatusService: Get.find<NetworkStatusService>(),
        tokenService: Get.find<TokenService>(),
      ),
    );
  }
}
