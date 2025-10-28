import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/auth_api_client.dart';
import '../storage/secure_storage_service.dart';
import '../network/auth_interceptor.dart';

/// Servicio para manejar refresh token automático
class TokenRefreshService {
  final SecureStorageService _storageService;
  final AuthApiClient _authApiClient;
  final AuthInterceptor _authInterceptor;
  
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  TokenRefreshService({
    required SecureStorageService storageService,
    required AuthApiClient authApiClient,
    required AuthInterceptor authInterceptor,
  })  : _storageService = storageService,
        _authApiClient = authApiClient,
        _authInterceptor = authInterceptor;

  /// Iniciar el servicio de refresh automático
  Future<void> start() async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      _scheduleRefresh();
    }
  }

  /// Detener el servicio de refresh automático
  void stop() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Programar el próximo refresh del token
  void _scheduleRefresh() {
    // Cancelar timer anterior si existe
    _refreshTimer?.cancel();
    
    // Programar refresh cada 50 minutos (tokens Laravel suelen durar 1 hora)
    _refreshTimer = Timer(const Duration(minutes: 50), () async {
      await _refreshToken();
    });
  }

  /// Refrescar el token manualmente
  Future<bool> refreshToken() async {
    if (_isRefreshing) {
      debugPrint('Token refresh already in progress');
      return false;
    }

    _isRefreshing = true;
    
    try {
      final response = await _authApiClient.refreshToken();
      
      if (response.token != null && response.token!.isNotEmpty) {
        await _storageService.saveToken(response.token!);
        debugPrint('Token refreshed successfully');
        
        // Programar próximo refresh
        _scheduleRefresh();
        
        return true;
      } else {
        debugPrint('Token refresh failed: empty token');
        await _handleRefreshFailure();
        return false;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      await _handleRefreshFailure();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refrescar el token (método privado para uso interno)
  Future<void> _refreshToken() async {
    await refreshToken();
  }

  /// Manejar fallo en el refresh del token
  Future<void> _handleRefreshFailure() async {
    // Limpiar tokens y preparar para logout
    await _authInterceptor.clearTokens();
    
    // Detener el servicio
    stop();
    
    debugPrint('Token refresh failed, user should be logged out');
  }

  /// Verificar si el token necesita refresh
  Future<bool> needsRefresh() async {
    final token = await _storageService.getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    // Aquí podrías implementar lógica para verificar la expiración del token
    // Por ahora, simplemente verificamos si existe
    return true;
  }

  /// Obtener tiempo restante hasta el próximo refresh
  Duration? getTimeUntilNextRefresh() {
    if (_refreshTimer?.isActive == true) {
      // No hay forma directa de obtener el tiempo restante de un Timer
      // En una implementación real, podrías usar un DateTime para trackear esto
      return null;
    }
    return null;
  }

  /// Forzar refresh inmediato
  Future<bool> forceRefresh() async {
    stop();
    return await refreshToken();
  }
}
