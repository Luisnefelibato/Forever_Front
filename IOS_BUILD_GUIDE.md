# 🍎 Guía Completa: Build de iOS (.ipa) para TestFlight desde Windows

## 📋 Requisitos Previos

Antes de empezar, necesitas tener:

### 1. **Apple Developer Account** ($99/año)
- Ir a: https://developer.apple.com
- Crear cuenta o usar cuenta existente
- Pagar membresía anual ($99 USD)

### 2. **App Store Connect Access**
- Ir a: https://appstoreconnect.apple.com
- Crear el registro de tu app

---

## 🎯 OPCIÓN 1: Codemagic CI/CD (RECOMENDADO desde Windows)

Esta es la mejor opción cuando **NO tienes Mac** y estás en Windows.

### Paso 1: Crear Cuenta en Codemagic

1. Ir a: https://codemagic.io/start/
2. **Sign up with GitHub** (usar tu cuenta de GitHub)
3. Autorizar acceso a tu repositorio: `Luisnefelibato/Forever_Front`

### Paso 2: Configurar el Proyecto en Codemagic

1. En el dashboard de Codemagic, hacer clic en **"Add application"**
2. Seleccionar tu repositorio: `Forever_Front`
3. Codemagic detectará automáticamente que es un proyecto Flutter
4. Seleccionar el archivo `codemagic.yaml` que ya está en el proyecto

### Paso 3: Obtener Certificados de Apple (CRÍTICO)

Necesitas generar estos archivos en Apple Developer:

#### A. App Store Connect API Key

1. Ir a: https://appstoreconnect.apple.com/access/api
2. Hacer clic en **"Keys"** → **"Generate API Key"**
3. Nombre: `Codemagic CI/CD`
4. Access: **App Manager**
5. **Descargar** el archivo `.p8` (solo se puede descargar UNA VEZ)
6. Anotar:
   - **Issuer ID** (encima de la tabla)
   - **Key ID** (en la columna de la key generada)
   - **Guardar el archivo .p8**

#### B. iOS Distribution Certificate

**IMPORTANTE:** Este paso normalmente requiere Mac, pero Codemagic puede manejarlo automáticamente.

**Opción A: Dejar que Codemagic lo maneje (MÁS FÁCIL)**
- Codemagic puede generar certificados automáticamente
- En la configuración del workflow, activar: **"Automatic code signing"**

**Opción B: Generar manualmente (requiere acceso temporal a Mac)**
1. Ir a: https://developer.apple.com/account/resources/certificates
2. Hacer clic en **"+"** para crear nuevo certificado
3. Seleccionar: **"iOS Distribution (App Store and Ad Hoc)"**
4. Seguir los pasos para generar el certificado

### Paso 4: Configurar Secrets en Codemagic

1. En Codemagic, ir a tu proyecto
2. Ir a **Settings** → **Environment variables**
3. Agregar las siguientes variables:

```
APP_STORE_CONNECT_ISSUER_ID = [Tu Issuer ID]
APP_STORE_CONNECT_KEY_IDENTIFIER = [Tu Key ID]
APP_STORE_CONNECT_PRIVATE_KEY = [Contenido del archivo .p8]
BUNDLE_ID = com.imagineapps.foreverusinlove
```

4. Marcar cada una como **"Secure"** (encrypted)

### Paso 5: Configurar Code Signing

1. En Codemagic, ir a **Code signing identities**
2. Agregar **iOS code signing**
3. Subir:
   - Certificado de distribución (.p12 o .cer)
   - Provisioning Profile (.mobileprovision)
   
**Si no tienes estos archivos:**
- Activar: **"Enable automatic code signing"**
- Codemagic los generará automáticamente

### Paso 6: Crear App en App Store Connect

1. Ir a: https://appstoreconnect.apple.com
2. Hacer clic en **"My Apps"** → **"+"** → **"New App"**
3. Completar información:
   - **Platform:** iOS
   - **Name:** ForeverUs InLove
   - **Primary Language:** Spanish (Spain)
   - **Bundle ID:** com.imagineapps.foreverusinlove (seleccionar del dropdown)
   - **SKU:** foreverusinlove-ios
   - **User Access:** Full Access

### Paso 7: Lanzar el Build

1. En Codemagic, ir a tu proyecto
2. Seleccionar el workflow: **"ios-workflow"**
3. Hacer clic en **"Start new build"**
4. Seleccionar:
   - **Branch:** main
   - **Workflow:** ios-workflow
5. Hacer clic en **"Start build"**

### Paso 8: Esperar el Build (15-25 minutos)

Codemagic hará automáticamente:
- ✅ Configurar el ambiente macOS con Xcode
- ✅ Instalar Flutter
- ✅ Descargar dependencias
- ✅ Compilar el proyecto
- ✅ Firmar la app con tus certificados
- ✅ Generar el archivo .ipa
- ✅ Subirlo a TestFlight automáticamente

### Paso 9: Verificar en TestFlight

1. Ir a: https://appstoreconnect.apple.com
2. Ir a **"My Apps"** → **"ForeverUs InLove"**
3. Ir a **"TestFlight"** en el menú lateral
4. Verás tu build en proceso de revisión

**Apple tarda aproximadamente:**
- ⏱️ **10-60 minutos** para revisar automáticamente
- Una vez aprobado, aparecerá como **"Ready to Test"**

### Paso 10: Agregar Testers

1. En TestFlight, ir a la pestaña **"Internal Testing"**
2. Hacer clic en **"+"** para agregar testers
3. Agregar emails de los testers (máximo 100 internal testers)
4. Los testers recibirán un email con instrucciones

---

## 🎯 OPCIÓN 2: GitHub Actions (Alternativa Gratuita)

Si prefieres usar GitHub Actions en lugar de Codemagic:

### Ventajas:
- ✅ Totalmente gratis
- ✅ Integrado con GitHub
- ✅ 2000 minutos gratuitos al mes

### Desventajas:
- ⚠️ Más complejo de configurar
- ⚠️ Requiere más configuración manual

*(Guía de GitHub Actions disponible si la necesitas)*

---

## 🎯 OPCIÓN 3: Usar Mac en la Nube (Alternativa)

### MacStadium / MacinCloud
- Alquilar un Mac virtual por $20-30/mes
- Acceso remoto vía VNC o RDP
- Instalar Xcode y Flutter
- Compilar manualmente

**Pasos:**
1. Registrarse en: https://www.macincloud.com
2. Seleccionar plan "Pay As You Go"
3. Conectar vía escritorio remoto
4. Instalar Xcode y Flutter
5. Clonar repositorio
6. Ejecutar: `flutter build ipa --release`

---

## 📱 Configuración Actual del Proyecto

### Bundle Identifier
```
com.imagineapps.foreverusinlove
```

### Display Name
```
Forever Us In Love
```

### Version
```
1.0.0 (Build 1)
```

### Supported iOS Versions
```
iOS 12.0 o superior
```

---

## 🔧 Comandos Útiles (si tienes acceso a Mac)

```bash
# Ver dispositivos disponibles
flutter devices

# Limpiar build anterior
flutter clean

# Obtener dependencias
flutter pub get

# Build para iOS (requiere Mac)
flutter build ios --release

# Build IPA (requiere Mac con Xcode)
flutter build ipa --release

# Subir manualmente a TestFlight (requiere Mac)
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/*.ipa \
  --apiKey YOUR_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID
```

---

## 🐛 Troubleshooting

### Error: "No provisioning profile found"
**Solución:** Activar "Automatic code signing" en Codemagic

### Error: "Bundle identifier mismatch"
**Solución:** Verificar que el Bundle ID sea exactamente: `com.imagineapps.foreverusinlove`

### Error: "Certificate expired"
**Solución:** Renovar certificado en Apple Developer y actualizar en Codemagic

### Error: "Build timed out"
**Solución:** Aumentar `max_build_duration` en codemagic.yaml a 180 minutos

---

## 📊 Costos Aproximados

| Servicio | Costo | Notas |
|----------|-------|-------|
| Apple Developer Account | $99/año | Obligatorio |
| Codemagic Free | $0 | 500 min/mes gratis |
| Codemagic Pro | $59/mes | Build ilimitados |
| GitHub Actions | $0 | 2000 min/mes gratis |
| MacinCloud | $20-30/mes | Solo si lo necesitas |

---

## ✅ Checklist Final

Antes de hacer el build, verifica:

- [ ] Cuenta de Apple Developer activa
- [ ] App creada en App Store Connect
- [ ] Bundle ID configurado correctamente
- [ ] Certificados y provisioning profiles listos
- [ ] API Key de App Store Connect generada
- [ ] Secrets configurados en Codemagic
- [ ] Código subido a GitHub en branch main
- [ ] Archivo codemagic.yaml en la raíz del proyecto

---

## 📞 Soporte

Si tienes problemas:

1. **Documentación de Codemagic:** https://docs.codemagic.io/flutter-code-signing/ios-code-signing/
2. **Apple Developer Support:** https://developer.apple.com/contact/
3. **Flutter iOS Deployment:** https://docs.flutter.dev/deployment/ios

---

## 🎉 Una vez que tengas el .ipa

1. El archivo .ipa se generará en: `build/ios/ipa/`
2. Codemagic lo subirá automáticamente a TestFlight
3. Recibirás email cuando esté listo para testing
4. Comparte el link de TestFlight con tus testers
5. Los testers instalan TestFlight app desde App Store
6. Los testers aceptan la invitación y pueden instalar la app

---

**¡Listo! Con esta guía deberías poder generar tu .ipa desde Windows sin problemas.** 🚀

---

**Última actualización:** 2025-10-24  
**Versión de la guía:** 1.0  
**Proyecto:** ForeverUs InLove - iOS Build
