# 🚀 QUICK START: iOS Build GRATIS en 5 minutos

## ⚡ Configuración Rápida

### 1. GitHub Actions (Recomendado)

```bash
# 1. Copiar el workflow
mkdir -p .github/workflows
cp github-workflows/ios-build-free.yml .github/workflows/

# 2. Commit y push
git add .github/workflows/ios-build-free.yml
git commit -m "Add free iOS build workflow"
git push

# 3. Ir a GitHub → Actions → "🆓 Free iOS Build" → Run workflow
```

### 2. Codemagic (Alternativa)

```bash
# 1. Crear cuenta en https://codemagic.io/
# 2. Conectar tu repositorio
# 3. El archivo codemagic.yaml ya está configurado
# 4. Click "Start new build"
```

## 🎯 Tipos de Build Disponibles

### Simulator Build (100% FREE)
- ✅ Funciona en iOS Simulator
- ✅ Perfecto para desarrollo
- ✅ No requiere Apple Developer Account
- ❌ No se puede instalar en iPhone real

### Unsigned IPA (Para desarrollo)
- ✅ Genera archivo .ipa
- ✅ Útil para testing
- ❌ No se puede instalar en iPhone real
- ❌ Requiere Apple Developer Account para instalación

## 📱 Cómo Probar tu App

### En iOS Simulator:
1. **Descargar Xcode** (gratis desde App Store)
2. **Abrir Xcode** → Window → Devices and Simulators
3. **Seleccionar simulador** (iPhone 15, iPhone 14, etc.)
4. **Arrastrar el .app** al simulador
5. **¡Listo!** Tu app se ejecutará

### En iPhone Real:
- ❌ **NO ES POSIBLE** sin Apple Developer Account ($99/año)
- ✅ **SÍ ES POSIBLE** con Apple Developer Account

## 🔧 Comandos Útiles

### Verificar configuración:
```bash
flutter doctor
flutter doctor -v
```

### Build local (si tienes Mac):
```bash
# Simulator
flutter build ios --simulator --debug

# Unsigned IPA
flutter build ios --debug --no-codesign
```

### Ver logs del workflow:
```bash
# En GitHub Actions, click en el workflow → Ver logs detallados
```

## ⚠️ Limitaciones Importantes

### SIN Apple Developer Account ($99/año):
- ✅ Compilar apps iOS
- ✅ Generar .ipa files
- ✅ Probar en simulador
- ❌ Instalar en iPhone real
- ❌ Subir a App Store
- ❌ Usar TestFlight

### CON Apple Developer Account ($99/año):
- ✅ Todo lo anterior
- ✅ Instalar en iPhone real
- ✅ Subir a App Store
- ✅ Usar TestFlight
- ✅ Firmar código

## 🆘 Solución de Problemas

### Error: "No iOS development team"
```bash
# Solución: Usar --no-codesign
flutter build ios --debug --no-codesign
```

### Error: "CocoaPods not found"
```bash
# Solución: Instalar CocoaPods
cd ios
pod install
```

### Error: "Xcode version not found"
```bash
# Solución: Verificar versión de Xcode
xcodebuild -version
```

## 📞 Soporte

Si tienes problemas:
1. **Revisa los logs** del workflow en GitHub Actions
2. **Verifica Flutter** con `flutter doctor`
3. **Consulta la guía completa** en `FREE_IOS_BUILD_GUIDE.md`
4. **Revisa la documentación** oficial de Flutter

## 🎉 ¡Listo!

Ahora puedes:
- ✅ Compilar apps iOS desde Windows
- ✅ Generar .ipa files gratis
- ✅ Probar en simulador iOS
- ✅ Desarrollar sin pagar $99/año

**Para instalar en iPhone real, necesitarás Apple Developer Account ($99/año), pero para desarrollo y testing, esta solución es perfecta y 100% gratuita.**

---

## 🔗 Enlaces Útiles

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos)
- [GitHub Actions](https://github.com/features/actions)
- [Codemagic](https://codemagic.io/)
- [Apple Developer Program](https://developer.apple.com/programs/)

¡Happy coding! 🚀
