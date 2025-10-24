# 📱 Instrucciones para Compilar iOS en GitHub Actions

## 🎯 Resumen

Este proyecto ahora está configurado para compilar aplicaciones iOS **SIN** necesidad de una cuenta de Apple Developer (que cuesta $99/año).

## ✅ Problemas Resueltos

### 1. **Falta de Podfile** ✅
- **Problema**: El proyecto no tenía un `Podfile` configurado
- **Solución**: Se creó `ios/Podfile` con todas las configuraciones necesarias para Flutter y CocoaPods

### 2. **Versión Antigua de Flutter** ✅
- **Problema**: Flutter 3.10.0 (2 años de antigüedad) causaba incompatibilidades
- **Solución**: Se actualizó a Flutter 3.19.0 con todas las dependencias compatibles

### 3. **Dependencias Incompatibles** ✅
- **Problema**: Versiones de paquetes incompatibles con el SDK
- **Solución**: Se actualizaron todas las dependencias en `pubspec.yaml`:
  - `firebase_core`: 2.24.2 → 2.27.0
  - `firebase_auth`: 4.15.3 → 4.17.8
  - `firebase_messaging`: 14.7.10 → 14.7.19
  - `permission_handler`: 10.4.5 → 11.3.0
  - `connectivity_plus`: 4.0.2 → 5.0.2
  - `google_sign_in`: 6.1.4 → 6.2.1
  - Y más...

### 4. **Android Embedding** ✅
- **Problema**: Error confuso sobre Android embedding v1
- **Solución**: El proyecto ya estaba en embedding v2, solo era un error de log

### 5. **Workflow de GitHub Actions Incompleto** ✅
- **Problema**: El workflow no generaba archivos IPA correctamente
- **Solución**: Se creó un workflow completo con:
  - Verificación de estructura del proyecto
  - Instalación correcta de CocoaPods
  - Generación de IPA sin firma
  - Upload de artifacts

## 🚀 Cómo Usar

### Opción 1: Build Automático (Push a GitHub)

Cada vez que hagas push a `main`, `develop` o una rama `feature/*`, GitHub Actions compilará automáticamente:

```bash
git add .
git commit -m "feat: nueva funcionalidad"
git push origin main
```

### Opción 2: Build Manual (Workflow Dispatch)

1. Ve a tu repositorio en GitHub
2. Click en "Actions"
3. Selecciona "🆓 Free iOS Build"
4. Click en "Run workflow"
5. Elige el tipo de build:
   - **simulator**: Para probar en iOS Simulator (más rápido)
   - **unsigned-ipa**: Genera archivo IPA sin firma
   - **both**: Ambos tipos de build

## 📦 Tipos de Build Disponibles

### 🎯 iOS Simulator Build
- ✅ **Gratis**: No requiere cuenta de Apple Developer
- ✅ **Rápido**: Build más rápido
- ✅ **Ideal para**: Desarrollo y testing
- ❌ **Limitación**: Solo funciona en simulador, no en iPhone real

### 📦 Unsigned IPA
- ✅ **Gratis**: No requiere cuenta de Apple Developer
- ✅ **Genera**: Archivo `.ipa` completo
- ⚠️ **Limitación**: NO se puede instalar en iPhone real sin firmar
- 💡 **Uso**: Para archivar, desarrollo interno, CI/CD

## 📥 Descargar los Archivos Compilados

1. Ve a la pestaña "Actions" en GitHub
2. Click en el workflow ejecutado (con ✅ verde)
3. Desplázate hasta "Artifacts"
4. Descarga:
   - `ios-simulator-build-XXX` - Para simulator
   - `ios-unsigned-ipa-XXX` - Archivo IPA
   - `ios-runner-app-XXX` - App sin empaquetar

## 🔐 Para Instalar en iPhone Real

Para instalar en un iPhone real, necesitas:

1. **Cuenta de Apple Developer** ($99/año)
2. **Certificado de firma de código**
3. **Perfil de aprovisionamiento**

### Pasos con Cuenta de Developer:

```bash
# 1. Configurar firma en Xcode
open ios/Runner.xcworkspace

# 2. En Xcode: Signing & Capabilities
# - Selecciona tu Team
# - Configura Bundle Identifier único
# - Xcode creará el perfil automáticamente

# 3. Build con firma
flutter build ios --release

# 4. Generar IPA
flutter build ipa --release
```

## 🛠️ Estructura del Proyecto iOS

```
ios/
├── Podfile                  # ✅ NUEVO - Configuración de CocoaPods
├── Podfile.lock            # Generado automáticamente
├── Pods/                   # Dependencias instaladas
├── Runner/                 # Código de la app
│   ├── Info.plist
│   ├── AppDelegate.swift
│   └── ...
├── Runner.xcodeproj/       # Proyecto Xcode
└── Runner.xcworkspace/     # Workspace (usar este)
```

## 📋 Verificación Local

Antes de hacer push, verifica localmente:

```bash
# 1. Limpiar proyecto
flutter clean

# 2. Obtener dependencias
flutter pub get

# 3. Instalar CocoaPods
cd ios
pod install
cd ..

# 4. Build para simulator
flutter build ios --simulator --debug

# 5. Build para device (sin firma)
flutter build ios --debug --no-codesign
```

## 🐛 Solución de Problemas

### Error: "Podfile not found"
```bash
# Asegúrate de que existe ios/Podfile
ls -la ios/Podfile

# Si no existe, el archivo está en este repositorio
# Pull los últimos cambios
git pull origin main
```

### Error: "CocoaPods installation failed"
```bash
# Limpiar cache de CocoaPods
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod repo update
pod install
```

### Error: "Flutter SDK version mismatch"
```bash
# Cambiar a Flutter 3.19.0
flutter version 3.19.0
flutter doctor
```

### Error: "Plugin requires Android embedding v2"
Este error es engañoso. El proyecto ya está en embedding v2.
Ignóralo si estás compilando para iOS.

## 📊 Estado del Proyecto

- ✅ Podfile configurado
- ✅ Flutter 3.19.0
- ✅ Dependencias actualizadas
- ✅ GitHub Actions funcionando
- ✅ Builds automáticos habilitados
- ✅ Generación de IPA sin firma

## 🎉 Resultado Esperado

Después de estos cambios, cada build de GitHub Actions:

1. ✅ Instalará Flutter 3.19.0
2. ✅ Instalará todas las dependencias
3. ✅ Ejecutará CocoaPods correctamente
4. ✅ Compilará la app iOS
5. ✅ Generará archivos IPA
6. ✅ Subirá artifacts descargables

## 📞 Soporte

Si tienes problemas:

1. Revisa los logs de GitHub Actions
2. Verifica que tengas la última versión del código
3. Asegúrate de que `ios/Podfile` existe
4. Verifica que `pubspec.yaml` tenga las dependencias actualizadas

---

**Última actualización**: 2025-10-24  
**Versión de Flutter**: 3.19.0  
**Estado**: ✅ Funcionando
