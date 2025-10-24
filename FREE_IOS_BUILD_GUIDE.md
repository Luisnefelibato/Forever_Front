# 🆓 Guía COMPLETA: Generar .ipa GRATIS desde Windows

## ⚠️ ADVERTENCIA IMPORTANTE

**Para instalar una app iOS en un iPhone REAL, necesitas:**
1. ✅ Archivo .ipa (puedes generar gratis)
2. ❌ Apple Developer Account ($99/año) - **OBLIGATORIO** para firma de código
3. ❌ Certificados de firma - Solo disponibles con cuenta de pago

**SIN la cuenta de $99:**
- ✅ Puedes compilar y generar el .ipa
- ❌ NO puedes instalarlo en iPhone real
- ✅ Solo puedes probarlo en simulador
- ✅ Perfecto para desarrollo y testing

---

## 🎯 OPCIONES 100% GRATUITAS

### Opción 1: GitHub Actions FREE (⭐ RECOMENDADA)

**Ventajas:**
- ✅ Completamente gratis (2000 minutos/mes)
- ✅ Mac real en la nube
- ✅ Fácil de configurar
- ✅ No requiere instalación local
- ✅ Automático con cada push

**Pasos:**

#### 1. Activar el workflow

```bash
# En tu proyecto local:
mkdir -p .github/workflows
cp github-workflows/ios-build-free.yml .github/workflows/
git add .github/workflows/ios-build-free.yml
git commit -m "Add free iOS build workflow"
git push
```

#### 2. Configurar en GitHub

1. Ve a tu repositorio en GitHub
2. Click en "Actions" tab
3. Selecciona "🆓 Free iOS Build"
4. Click "Run workflow"
5. Elige el tipo de build:
   - **simulator**: Para probar en simulador iOS
   - **unsigned-ipa**: Para generar .ipa sin firma

#### 3. Descargar el build

1. Ve a la pestaña "Actions" en GitHub
2. Click en el workflow que acabas de ejecutar
3. Scroll down hasta "Artifacts"
4. Descarga el archivo generado

---

### Opción 2: MacOS Virtual en Windows (Hackintosh VM)

**Herramientas:**
- VirtualBox (gratis)
- Imagen de macOS (técnicamente zona gris legal)
- Flutter y Xcode

**Pasos:**

#### 1. Descargar VirtualBox
```
https://www.virtualbox.org/wiki/Downloads
```

#### 2. Descargar imagen de macOS
```
Buscar: "macOS Monterey/Ventura VirtualBox image"
Sitios recomendados: 
- https://www.geekrar.com (no oficial)
- Torrents de macOS VirtualBox
```

#### 3. Configurar VM
```
- Mínimo 8GB RAM
- 60GB disco
- 2+ CPU cores
- Habilitar virtualization en BIOS
```

#### 4. Instalar macOS en VirtualBox

**Configuración de VM:**
```bash
# En CMD de Windows como Administrador:
cd "C:\Program Files\Oracle\VirtualBox\"

VBoxManage modifyvm "macOS" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,1"
VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-AA95B1DDAB278B95"
VBoxManage setextradata "macOS" "VBoxInternal/TM/TSCMode" "RealTSCOffset"
VBoxManage setextradata "macOS" "VBoxInternal2/EfiGraphicsResolution" "1920x1080"
```

#### 5. Iniciar macOS VM e instalar

**Una vez en macOS:**
```bash
# Instalar Xcode desde App Store (gratis pero necesitas Apple ID)
# Instalar Flutter
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.0-stable.zip
unzip flutter.zip
sudo mv flutter /usr/local/

# Agregar a PATH
echo 'export PATH="$PATH:/usr/local/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Verificar instalación
flutter doctor
```

#### 6. Compilar tu proyecto
```bash
# Clonar tu repo
git clone https://github.com/Luisnefelibato/Forever_Front.git
cd Forever_Front

# Obtener dependencias
flutter pub get

# Compilar para iOS (simulador)
flutter build ios --debug --simulator

# O compilar para dispositivo (sin firma)
flutter build ios --debug --no-codesign
```

**Resultado:**
- ✅ Genera el .app en `build/ios/iphoneos/`
- ❌ NO está firmado (no se puede instalar en iPhone real)
- ✅ Puedes probar en simulador

**Limitaciones:**
- ⚠️ Muy lento (VM de macOS)
- ⚠️ Zona gris legal (violación EULA de Apple)
- ⚠️ Puede ser inestable
- ⚠️ NO puedes firmarlo sin cuenta de $99

---

### Opción 3: Codemagic FREE (Alternativa a GitHub Actions)

**Ventajas:**
- ✅ 500 minutos gratis al mes
- ✅ Mac real en la nube
- ✅ Interfaz más amigable
- ✅ Builds más rápidos

**Pasos:**

#### 1. Crear cuenta en Codemagic
```
https://codemagic.io/
```

#### 2. Conectar tu repositorio
1. Login en Codemagic
2. Click "Add application"
3. Selecciona tu repositorio de GitHub
4. Configura el workflow

#### 3. Configurar workflow

Crea `codemagic.yaml` en la raíz de tu proyecto:

```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 60
    environment:
      vars:
        XCODE_WORKSPACE: "ios/Runner.xcworkspace"
        XCODE_SCHEME: "Runner"
      xcode: latest
      cocoapods: default
    scripts:
      - name: Set up keychain to be used for codesigning
        script: |
          keychain initialize
      - name: Fetch signing files
        script: |
          # No signing files needed for free builds
          echo "Building without code signing"
      - name: Set up signing certificate
        script: |
          # No certificate needed for free builds
          echo "Skipping certificate setup"
      - name: Set up provisioning profile
        script: |
          # No provisioning profile needed for free builds
          echo "Skipping provisioning profile setup"
      - name: Install Flutter
        script: |
          flutter --version
          flutter pub get
      - name: Flutter analyze
        script: |
          flutter analyze
      - name: Flutter unit tests
        script: |
          flutter test
      - name: Install pods
        script: |
          find . -name "Podfile" -execdir pod install \;
      - name: Flutter build ipa
        script: |
          flutter build ipa --release --no-codesign
    artifacts:
      - build/ios/ipa/*.ipa
      - /tmp/xcodebuild_logs/*.log
      - flutter_drive.log
```

#### 4. Ejecutar build
1. Ve a tu app en Codemagic
2. Click "Start new build"
3. Selecciona la rama
4. Click "Start build"

---

## 🚀 Cómo usar los builds generados

### Para iOS Simulator:

1. **Descargar el build** desde GitHub Actions o Codemagic
2. **Instalar Xcode** en Mac (gratis desde App Store)
3. **Abrir Xcode** → Window → Devices and Simulators
4. **Seleccionar un simulador** (iPhone 15, iPhone 14, etc.)
5. **Arrastrar el .app** al simulador
6. **¡Listo!** Tu app se ejecutará en el simulador

### Para desarrollo:

1. **Usar el .app** generado para testing
2. **Probar funcionalidades** en simulador
3. **Debug** usando Xcode
4. **Iterar** y mejorar tu app

---

## 💡 Consejos y Trucos

### 1. Optimizar builds:
```yaml
# En tu workflow, agregar cache:
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      **/pubspec.lock
    key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
    restore-keys: |
      ${{ runner.os }}-pub-
```

### 2. Builds automáticos:
```yaml
# Trigger automático en cada push:
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
```

### 3. Múltiples versiones de iOS:
```yaml
strategy:
  matrix:
    ios-version: ['15.0', '16.0', '17.0']
```

### 4. Notificaciones:
```yaml
- name: Notify on success
  if: success()
  run: |
    echo "✅ Build completed successfully!"
    # Aquí puedes agregar notificaciones a Slack, Discord, etc.
```

---

## 🔧 Solución de Problemas

### Error: "No iOS development team"
```
Solución: Usar --no-codesign flag
flutter build ios --debug --no-codesign
```

### Error: "CocoaPods not found"
```
Solución: Instalar CocoaPods en el workflow
- name: Install CocoaPods
  run: |
    cd ios
    pod install
```

### Error: "Xcode version not found"
```
Solución: Especificar versión de Xcode
- name: Setup Xcode
  uses: maxim-lobanov/setup-xcode@v1
  with:
    xcode-version: '15.0'
```

### Error: "Flutter doctor issues"
```
Solución: Verificar configuración
- name: Flutter doctor
  run: flutter doctor -v
```

---

## 📱 Próximos Pasos

### Si quieres instalar en iPhone real:

1. **Comprar Apple Developer Account** ($99/año)
2. **Configurar certificados** de firma
3. **Crear provisioning profiles**
4. **Firmar el .ipa** con certificados válidos
5. **Instalar via Xcode** o TestFlight

### Alternativas gratuitas para testing:

1. **iOS Simulator** (gratis con Xcode)
2. **TestFlight** (gratis con Apple Developer Account)
3. **Ad Hoc distribution** (gratis con Apple Developer Account)

---

## 🎉 ¡Felicitaciones!

Ahora tienes todo lo necesario para:
- ✅ Compilar apps iOS desde Windows
- ✅ Generar .ipa files gratis
- ✅ Probar en simulador iOS
- ✅ Desarrollar sin pagar $99/año

**Recuerda:** Para instalar en iPhone real, necesitarás la cuenta de Apple Developer ($99/año), pero para desarrollo y testing, esta solución es perfecta y 100% gratuita.

---

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs del workflow
2. Verifica la configuración de Flutter
3. Asegúrate de que todas las dependencias estén instaladas
4. Consulta la documentación oficial de Flutter

¡Happy coding! 🚀
