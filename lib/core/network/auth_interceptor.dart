import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'auth_api_client.dart';

/// Interceptor para manejar autenticación automática y refresh token
class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;
  final AuthApiClient _authApiClient;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor({
    required SecureStorageService storageService,
    required AuthApiClient authApiClient,
  })  : _storageService = storageService,
        _authApiClient = authApiClient;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Agregar token de autorización si está disponible
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Agregar headers necesarios para Laravel
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Solo manejar errores 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      // Si ya estamos refrescando, agregar a la cola de espera
      if (_isRefreshing) {
        _pendingRequests.add(err.requestOptions);
        return;
      }

      try {
        await _refreshTokenAndRetry(err, handler);
      } catch (e) {
        // Si el refresh falla, limpiar tokens y redirigir al login
        await _clearTokensAndRedirect();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  /// Refrescar token y reintentar peticiones pendientes
  Future<void> _refreshTokenAndRetry(DioException err, ErrorInterceptorHandler handler) async {
    _isRefreshing = true;

    try {
      // Intentar refrescar el token
      final response = await _authApiClient.refreshToken();
      
      if (response.token != null && response.token!.isNotEmpty) {
        // Guardar nuevo token
        await _storageService.saveToken(response.token!);
        
        // Actualizar headers de la petición original
        err.requestOptions.headers['Authorization'] = 'Bearer ${response.token}';
        
        // Reintentar petición original
        final dio = Dio();
        final retryResponse = await dio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
        
        // Procesar peticiones pendientes
        await _processPendingRequests(response.token!);
      } else {
        throw Exception('Token refresh failed: empty token');
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      throw e;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Procesar peticiones que estaban esperando el refresh
  Future<void> _processPendingRequests(String newToken) async {
    final dio = Dio();
    
    for (final requestOptions in _pendingRequests) {
      try {
        requestOptions.headers['Authorization'] = 'Bearer $newToken';
        await dio.fetch(requestOptions);
      } catch (e) {
        debugPrint('Failed to retry pending request: $e');
      }
    }
    
    _pendingRequests.clear();
  }

  /// Limpiar tokens y preparar para redirección al login
  Future<void> _clearTokensAndRedirect() async {
    try {
      await _storageService.clearToken();
      await _storageService.clearAll(); // Esto limpia todo incluyendo userId
      debugPrint('Tokens cleared, user should be redirected to login');
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
    }
  }

  /// Método público para limpiar tokens (útil para logout)
  Future<void> clearTokens() async {
    await _clearTokensAndRedirect();
  }
}