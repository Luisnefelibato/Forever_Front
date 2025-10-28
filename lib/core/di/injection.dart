import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/auth_api_client.dart';
import '../network/auth_interceptor.dart';
import '../storage/secure_storage_service.dart';
import '../services/token_refresh_service.dart';
import '../../features/auth/domain/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart' as data_source;
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/services/social_auth_service.dart';
import '../../features/auth/data/services/auth_service.dart';

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
    () => AuthApiClient(DioClient.instance),
  );

  // Auth Interceptor for automatic token refresh
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      storageService: getIt<SecureStorageService>(),
      authApiClient: getIt<AuthApiClient>(),
    ),
  );

  // Token Refresh Service
  getIt.registerLazySingleton<TokenRefreshService>(
    () => TokenRefreshService(
      storageService: getIt<SecureStorageService>(),
      authApiClient: getIt<AuthApiClient>(),
      authInterceptor: getIt<AuthInterceptor>(),
    ),
  );
}

void _registerAuthDependencies() {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => data_source.AuthRemoteDataSourceImpl(apiClient: getIt<AuthApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );

  // Social Auth Service
  getIt.registerLazySingleton<SocialAuthService>(
    () => SocialAuthService(authRepository: getIt<AuthRepository>()),
  );

  // Auth Service
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      authRepository: getIt<AuthRepository>(),
      tokenRefreshService: getIt<TokenRefreshService>(),
    ),
  );
}
