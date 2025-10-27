import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/auth_api_client.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

/// Configure dependency injection
Future<void> configureDependencies() async {
  // Register dependencies
  _registerCoreDependencies();
  _registerAuthDependencies();
}

void _registerCoreDependencies() {
  // Storage
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // Dio Client
  getIt.registerLazySingleton(
    () => DioClient.instance,
  );

  // API Client
  getIt.registerLazySingleton<AuthApiClient>(
    () => AuthApiClient(getIt()),
  );
}

void _registerAuthDependencies() {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      storageService: getIt(),
    ),
  );
}
