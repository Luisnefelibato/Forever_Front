# 💳 Verification Payment Integration Guide

Esta guía explica cómo integrar las pantallas de verificación creadas con los servicios de pago (Apple Pay/Google Pay) y el SDK de Onfido.

## 📁 Archivos Creados

```
lib/features/verification/
├── presentation/
│   └── pages/
│       ├── verification_intro_page.dart         ✅ Pantalla principal de introducción
│       ├── verification_payment_page.dart       ✅ Pantalla de pago (Apple/Google Pay)
│       ├── verification_processing_page.dart    ✅ Pantalla de procesamiento (3 segundos)
│       ├── onfido_verification_page.dart        ✅ Pantalla que lanza Onfido SDK
│       └── pages.dart                           ✅ Export file
```

## 🎯 Flujo Completo Implementado

```
1. AboutYou Form (existente)
   ↓
2. Pantalla de introducción "Why Verification Matters"
   - Explica beneficios de verificación
   - Muestra fee de $1.99
   - Botón "Proceed to pay verification"
   - Botón "Skip" (con advertencia)
   ↓
3. Pantalla de Pago
   - Muestra detalles del pago
   - Botón de Apple Pay (iOS) o Google Pay (Android)
   - Procesa el pago
   ↓
4. Pantalla de Procesamiento (3 segundos)
   - Animación de éxito del pago
   - Mensaje de procesamiento
   ↓
5. Lanzar SDK de Onfido
   - Captura de documento
   - Captura facial
   - Liveness check
   - NFC reading (opcional)
   ↓
6. Retornar a la app
   - Solo regresa cuando la verificación está completa
   - Backend procesa webhook de Onfido
   - Usuario recibe confirmación
```

## 🔧 Integración Pendiente

### 1. Agregar Rutas de Navegación

Agregar estas rutas en tu archivo de rutas (probablemente `lib/core/routing/app_router.dart` o similar):

```dart
// Agregar estas rutas
'/verification/intro': (context) => const VerificationIntroPage(),
'/verification/payment': (context) => const VerificationPaymentPage(),
'/verification/processing': (context) => const VerificationProcessingPage(),
'/verification/onfido': (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return OnfidoVerificationPage(
    sdkToken: args['sdk_token'],
    workflowRunId: args['workflow_run_id'],
  );
},
```

### 2. Conectar desde AboutYou Flow

Actualizar el flujo después de completar "About You" para navegar a la pantalla de verificación:

```dart
// En about_you_location_page.dart o donde termina el flujo AboutYou
Navigator.pushNamed(context, '/verification/intro');
```

### 3. Integrar Apple Pay / Google Pay

#### Opción A: pay (Recomendado)

Agregar al `pubspec.yaml`:

```yaml
dependencies:
  pay: ^2.0.0
```

Implementar en `verification_payment_page.dart`:

```dart
import 'package:pay/pay.dart';

// Configuración de Apple Pay
final applePayButton = ApplePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
    defaultApplePay,
  ),
  paymentItems: [
    PaymentItem(
      label: 'Identity Verification',
      amount: '1.99',
      status: PaymentItemStatus.final_price,
    ),
  ],
  onPaymentResult: (result) {
    // Procesar resultado del pago
    _handlePaymentSuccess(result);
  },
);

// Configuración de Google Pay
final googlePayButton = GooglePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
    defaultGooglePay,
  ),
  paymentItems: [
    PaymentItem(
      label: 'Identity Verification',
      amount: '1.99',
      status: PaymentItemStatus.final_price,
    ),
  ],
  onPaymentResult: (result) {
    // Procesar resultado del pago
    _handlePaymentSuccess(result);
  },
);
```

Archivos de configuración necesarios:

**assets/default_payment_profile_apple_pay.json**:
```json
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.foreverusinlove",
    "displayName": "ForeverUs In Love",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD"
  }
}
```

**assets/default_payment_profile_google_pay.json**:
```json
{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD", "AMEX"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantName": "ForeverUs In Love"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}
```

Agregar assets en `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/default_payment_profile_apple_pay.json
    - assets/default_payment_profile_google_pay.json
```

#### Opción B: Integración con Stripe

Si prefieres usar Stripe con Apple Pay/Google Pay:

```yaml
dependencies:
  flutter_stripe: ^10.1.1
```

```dart
import 'package:flutter_stripe/flutter_stripe.dart';

// Inicializar Stripe
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    merchantDisplayName: 'ForeverUs In Love',
    paymentIntentClientSecret: clientSecret,
    applePay: PaymentSheetApplePay(
      merchantCountryCode: 'US',
    ),
    googlePay: PaymentSheetGooglePay(
      merchantCountryCode: 'US',
      testEnv: true,
    ),
  ),
);

// Mostrar payment sheet
await Stripe.instance.presentPaymentSheet();
```

### 4. Integrar SDK de Onfido

Agregar al `pubspec.yaml`:

```yaml
dependencies:
  onfido_sdk: ^10.0.0  # Última versión estable
```

#### Configuración iOS

**ios/Podfile**:
```ruby
platform :ios, '13.0'
```

**ios/Runner/Info.plist**:
```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a tu cámara para capturar tu documento de identidad y foto facial</string>

<key>NSMicrophoneUsageDescription</key>
<string>Necesitamos acceso al micrófono para captura de video durante la verificación</string>

<key>NFCReaderUsageDescription</key>
<string>Necesitamos acceso a NFC para leer el chip de tu pasaporte</string>
```

#### Configuración Android

**android/app/build.gradle**:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

**android/app/src/main/AndroidManifest.xml**:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.NFC" />
```

#### Implementar en `onfido_verification_page.dart`

Reemplazar el código simulado con:

```dart
import 'package:onfido_sdk/onfido_sdk.dart';

Future<void> _initializeOnfido() async {
  try {
    // Configurar Onfido
    final onfido = Onfido(
      sdkToken: widget.sdkToken,
      onfidoTheme: OnfidoTheme.AUTOMATIC,
      nfcOption: NFCOptions.OPTIONAL,
    );

    // Iniciar workflow
    await onfido.startWorkflow(widget.workflowRunId);

    // Si llegamos aquí, la verificación se completó
    if (mounted) {
      await _handleVerificationComplete();
    }
  } on PlatformException catch (e) {
    // Manejar errores
    if (e.code == 'exit') {
      _handleCancellation();
    } else {
      _handleError(e.message ?? 'Unknown error');
    }
  }
}
```

### 5. Crear Servicios Backend

Crear el servicio para comunicarse con tu backend:

**lib/features/verification/data/services/verification_api_service.dart**:

```dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'verification_api_service.g.dart';

@RestApi()
abstract class VerificationApiService {
  factory VerificationApiService(Dio dio, {String baseUrl}) = _VerificationApiService;

  @POST('/api/v1/verification/create')
  Future<Map<String, dynamic>> createVerificationSession(
    @Body() Map<String, dynamic> data,
  );

  @GET('/api/v1/verification/status')
  Future<Map<String, dynamic>> getVerificationStatus();
}
```

Luego ejecutar:
```bash
cd /home/user/webapp && flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Implementar Método Real de Pago

En `verification_payment_page.dart`, reemplazar `_handlePayment` con:

```dart
Future<void> _handlePayment() async {
  setState(() {
    _isProcessing = true;
    _errorMessage = null;
  });

  try {
    // 1. Procesar pago con Apple Pay / Google Pay
    final paymentResult = await _processPayment();
    
    if (!paymentResult.success) {
      throw Exception('Payment was not successful');
    }

    // 2. Crear sesión de verificación en el backend
    final apiService = GetIt.instance<VerificationApiService>();
    final sessionData = await apiService.createVerificationSession({
      'payment_transaction_id': paymentResult.transactionId,
    });

    final sdkToken = sessionData['sdk_token'];
    final workflowRunId = sessionData['workflow_run_id'];

    if (!mounted) return;

    // 3. Mostrar pantalla de procesamiento
    await Navigator.pushNamed(context, '/verification/processing');

    if (!mounted) return;

    // 4. Lanzar Onfido SDK
    final onfidoResult = await Navigator.pushNamed(
      context,
      '/verification/onfido',
      arguments: {
        'sdk_token': sdkToken,
        'workflow_run_id': workflowRunId,
      },
    );

    if (!mounted) return;

    if (onfidoResult == true) {
      Navigator.pop(context, true);
    }
  } catch (e) {
    setState(() {
      _errorMessage = e.toString();
      _isProcessing = false;
    });
  }
}

Future<PaymentResult> _processPayment() async {
  // Implementar con pay package o Stripe
  // Ver ejemplos arriba
}
```

### 7. Endpoints Backend Necesarios

Tu backend Laravel debe implementar estos endpoints (ver `ONFIDO_VERIFICATION_IMPLEMENTATION.md` para detalles completos):

#### POST /api/v1/verification/create

**Request**:
```json
{
  "payment_transaction_id": "txn_123456"
}
```

**Response**:
```json
{
  "applicant_id": "abc-123",
  "workflow_run_id": "wfr-456",
  "sdk_token": "sdk_token_xyz",
  "expires_at": "2025-11-04T10:00:00Z"
}
```

#### GET /api/v1/verification/status

**Response**:
```json
{
  "status": "awaiting_input|processing|approved|review|declined",
  "created_at": "2025-10-28T10:00:00Z",
  "completed_at": "2025-10-28T10:05:00Z",
  "result": {
    "document_verified": true,
    "face_verified": true,
    "overall": "clear|consider"
  }
}
```

#### POST /api/v1/webhooks/onfido

Webhook para recibir notificaciones de Onfido cuando la verificación se completa.

## 🔄 Flujo de Advertencia "Skip"

La pantalla de introducción incluye un diálogo de advertencia cuando el usuario presiona "Skip":

```dart
void _handleSkip() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Skip Verification?'),
      content: const Text(
        'Without verification, you may have limited access to features and other verified members may not trust your profile.\n\nAre you sure you want to skip?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can verify your identity later from settings'),
                backgroundColor: Colors.orange,
              ),
            );
          },
          child: const Text('Skip Anyway', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

## 🎨 Diseño Implementado

### Colores Utilizados

```dart
// Verde principal (botones de acción)
Color(0xFF34C759)

// Fondo claro de checkmarks
Color(0xFFD1F2DD)

// Fondo blanco
Colors.white

// Texto principal
Colors.black

// Texto secundario
Colors.black87, Colors.black54

// Fondo de info boxes
Colors.grey[200]
```

### Tipografía

- **Títulos principales**: 32px, bold
- **Subtítulos**: 20px, bold
- **Texto normal**: 16px, regular
- **Texto pequeño**: 13-14px, regular

### Componentes

- **Checkmarks verdes**: Círculos con fondo verde claro y check verde
- **Info boxes**: Fondo gris claro con ícono de info
- **Botones**: Altura 56px, border radius 28px
- **Espaciado**: 12-32px entre elementos

## 📱 Soporte de Plataformas

- **iOS**: Apple Pay nativo
- **Android**: Google Pay nativo
- **Onfido SDK**: iOS 13+ y Android API 21+

## 🔐 Seguridad

- ✅ Tokens SDK generados en el backend
- ✅ Validación de pago antes de crear sesión
- ✅ Webhooks firmados de Onfido
- ✅ Datos encriptados y nunca compartidos
- ✅ Diálogos de confirmación para acciones importantes

## 🧪 Testing

Para probar sin integración real:

1. Las pantallas actuales tienen simulaciones implementadas
2. El pago simula un 90% de éxito
3. El SDK de Onfido muestra un diálogo simulado con los pasos
4. Después de 3 segundos en "processing", pasa a Onfido

Para testing real:

1. Configurar credenciales de Onfido en modo sandbox
2. Usar tarjetas de prueba de Stripe/Apple Pay
3. Verificar webhooks con ngrok o similar

## 📝 Próximos Pasos

1. ✅ Pantallas creadas
2. ⏳ Agregar rutas de navegación
3. ⏳ Integrar paquete de pago (pay o flutter_stripe)
4. ⏳ Agregar SDK de Onfido
5. ⏳ Implementar servicio de API
6. ⏳ Conectar con endpoints del backend
7. ⏳ Testing completo del flujo
8. ⏳ Configurar webhooks de Onfido
9. ⏳ Testing en dispositivos reales

## 🆘 Troubleshooting

### Error: "Cannot find payment configuration"
- Asegúrate de crear los archivos JSON de configuración de pago
- Agrega los assets en pubspec.yaml

### Error: "Onfido SDK not initialized"
- Verifica que el SDK esté instalado: `flutter pub get`
- Revisa permisos en Info.plist (iOS) y AndroidManifest.xml

### Error: "Payment failed"
- Verifica credenciales de Stripe/Apple Pay/Google Pay
- Usa modo sandbox/test para desarrollo

### Error: "Invalid SDK token"
- Verifica que el backend esté generando tokens válidos
- El token debe ser generado con las credenciales correctas de Onfido

## 📚 Referencias

- [Onfido Flutter SDK](https://github.com/onfido/flutter-sdk)
- [Pay Package](https://pub.dev/packages/pay)
- [Flutter Stripe](https://pub.dev/packages/flutter_stripe)
- [Apple Pay Integration](https://developer.apple.com/apple-pay/)
- [Google Pay Integration](https://developers.google.com/pay)

---

**Nota**: Las pantallas están listas para usar. Solo necesitas:
1. Agregar las rutas
2. Integrar los servicios de pago
3. Agregar el SDK de Onfido
4. Conectar con tu backend

Todo el diseño y flujo de UI está completamente implementado y siguiendo las especificaciones de la imagen proporcionada.
