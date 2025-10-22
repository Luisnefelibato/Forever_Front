import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

/// Configure dependency injection
/// 
/// This function will be called at app startup to register all dependencies
/// Use @injectable annotation in classes to auto-register them
@InjectableInit()
Future<void> configureDependencies() async {
  // TODO: Add generated code here when running build_runner
  // await getIt.init();
  
  // Manual registration for now (until code generation is set up)
  _registerCoreDependencies();
  _registerAuthDependencies();
}

void _registerCoreDependencies() {
  // Register core dependencies (network, storage, etc.)
  // Example:
  // getIt.registerLazySingleton<Dio>(() => createDioInstance());
}

void _registerAuthDependencies() {
  // Register auth-related dependencies
  // Example:
  // getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));
}
