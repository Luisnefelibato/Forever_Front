# 🔧 Configuración de Plataformas para Onfido SDK

## 📱 Android Configuration

### 1. Permisos en AndroidManifest.xml
Agregar en `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.NFC" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. Configuración de ProGuard
Agregar en `android/app/proguard-rules.pro`:

```proguard
# Onfido SDK
-keep class com.onfido.** { *; }
-keep class com.onfido.sdk.** { *; }
-dontwarn com.onfido.**
```

### 3. Configuración de Gradle
En `android/app/build.gradle`, asegurar:

```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## 🍎 iOS Configuration

### 1. Permisos en Info.plist
Agregar en `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and facial capture</string>
<key>NSMicrophoneUsageDescription</key>
<string>Required for video capture</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Required for document upload</string>
<key>NFCReaderUsageDescription</key>
<string>Required for NFC document reading</string>
```

### 2. Configuración de Podfile
En `ios/Podfile`:

```ruby
platform :ios, '13.0'
```

### 3. Configuración de Xcode
- Deployment Target: iOS 13.0+
- Enable Bitcode: NO
- Swift Language Version: Swift 5

## 🔐 Configuración de Seguridad

### Variables de Entorno
Crear archivo `.env` en la raíz del proyecto:

```env
# Onfido Configuration
ONFIDO_API_TOKEN=EYFA0st4yuXDVrldNshBRtj4zfIgAoAlw89BsvnZ4IE
ONFIDO_WORKFLOW_ID=2e849672-bc5e-449a-9feb-c40ccde8b575
ONFIDO_ENVIRONMENT=live
ONFIDO_BASE_URL=http://3.232.35.26:8000/api/v1
```

### Configuración de Build
Para diferentes entornos:

```dart
// lib/core/config/environment.dart
class Environment {
  static const String onfidoApiToken = String.fromEnvironment(
    'ONFIDO_API_TOKEN',
    defaultValue: 'EYFA0st4yuXDVrldNshBRtj4zfIgAoAlw89BsvnZ4IE',
  );
  
  static const String onfidoWorkflowId = String.fromEnvironment(
    'ONFIDO_WORKFLOW_ID',
    defaultValue: '2e849672-bc5e-449a-9feb-c40ccde8b575',
  );
  
  static const String onfidoEnvironment = String.fromEnvironment(
    'ONFIDO_ENVIRONMENT',
    defaultValue: 'live',
  );
}
```

## 🚀 Comandos de Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
flutter build ipa --release
```

## 📋 Checklist de Implementación

### ✅ Completado
- [x] Dependencias instaladas (onfido_sdk, dio, get_it)
- [x] Configuración de Onfido creada
- [x] Servicios de API implementados
- [x] Páginas de verificación creadas
- [x] Token de API de producción configurado

### 🔄 Pendiente
- [ ] Configurar permisos en AndroidManifest.xml
- [ ] Configurar permisos en Info.plist
- [ ] Configurar ProGuard para Android
- [ ] Actualizar Podfile para iOS
- [ ] Implementar endpoints en el backend
- [ ] Testing en dispositivos reales
- [ ] Configurar webhooks de Onfido

## 🧪 Testing

### Dispositivos de Prueba
- **Android**: API Level 21+ (Android 5.0+)
- **iOS**: iOS 13.0+
- **Web**: Chrome 90+, Safari 14+, Firefox 88+

### Casos de Prueba
1. **Flujo completo**: Pago → Verificación → Resultado
2. **Cancelación**: Usuario cancela en diferentes pasos
3. **Errores de red**: Sin conexión, timeout
4. **Permisos**: Usuario niega permisos de cámara
5. **Documentos**: Diferentes tipos de documentos
6. **NFC**: Dispositivos con/sin NFC

## 📞 Soporte

### Onfido Support
- **Email**: support@onfido.com
- **Documentación**: https://documentation.onfido.com/
- **Status Page**: https://status.onfido.com/

### ForeverUsInLove Support
- **Backend**: http://3.232.35.26:8000/api/v1
- **Token**: EYFA0st4yuXDVrldNshBRtj4zfIgAoAlw89BsvnZ4IE
- **Workflow**: flutter_new (2e849672-bc5e-449a-9feb-c40ccde8b575)
