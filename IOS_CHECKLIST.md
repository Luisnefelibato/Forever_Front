# ✅ Checklist: Build iOS desde Windows

## 📋 ANTES DE EMPEZAR

### Requisitos Obligatorios
- [ ] Cuenta de Apple Developer ($99/año) - https://developer.apple.com
- [ ] Acceso a GitHub (repo: Luisnefelibato/Forever_Front)
- [ ] Correo electrónico para notificaciones

---

## 🚀 PASO A PASO CON CODEMAGIC

### Fase 1: Setup Inicial (10 minutos)

- [ ] **1.1** Crear cuenta en Codemagic
  - Ir a: https://codemagic.io/start/
  - Sign up con GitHub
  - Autorizar acceso al repositorio

- [ ] **1.2** Conectar repositorio
  - En Codemagic dashboard: "Add application"
  - Seleccionar: `Luisnefelibato/Forever_Front`
  - Codemagic detecta automáticamente el proyecto Flutter

- [ ] **1.3** Verificar archivos del proyecto
  - ✅ `codemagic.yaml` existe en la raíz
  - ✅ `ios/Runner/Info.plist` tiene permisos
  - ✅ `ios/ExportOptions.plist` existe

### Fase 2: Apple Developer Setup (15 minutos)

- [ ] **2.1** Generar App Store Connect API Key
  - Ir a: https://appstoreconnect.apple.com/access/api
  - Clic en "Keys" → "Generate API Key"
  - Nombre: `Codemagic CI/CD`
  - Access: **App Manager**
  - **DESCARGAR archivo .p8** (solo se puede una vez!)
  
- [ ] **2.2** Guardar información importante
  ```
  Issuer ID: _______________________________
  Key ID: ___________________________________
  Archivo .p8 guardado en: __________________
  ```

- [ ] **2.3** Crear app en App Store Connect
  - Ir a: https://appstoreconnect.apple.com
  - My Apps → "+" → "New App"
  - Completar:
    * Platform: **iOS**
    * Name: **ForeverUs InLove**
    * Primary Language: **Spanish (Spain)**
    * Bundle ID: **com.imagineapps.foreverusinlove**
    * SKU: **foreverusinlove-ios**

### Fase 3: Configurar Codemagic (5 minutos)

- [ ] **3.1** Agregar Environment Variables
  - En Codemagic: Settings → Environment variables
  - Agregar variable:
    * Name: `APP_STORE_CONNECT_ISSUER_ID`
    * Value: [tu Issuer ID]
    * ✅ Marcar como "Secure"
    
  - Agregar variable:
    * Name: `APP_STORE_CONNECT_KEY_IDENTIFIER`
    * Value: [tu Key ID]
    * ✅ Marcar como "Secure"
    
  - Agregar variable:
    * Name: `APP_STORE_CONNECT_PRIVATE_KEY`
    * Value: [contenido completo del archivo .p8]
    * ✅ Marcar como "Secure"
    
  - Agregar variable:
    * Name: `BUNDLE_ID`
    * Value: `com.imagineapps.foreverusinlove`
    * ✅ Marcar como "Secure"

- [ ] **3.2** Configurar Code Signing
  - Settings → Code signing identities
  - iOS code signing
  - ✅ Activar: **"Enable automatic code signing"**
  - Dejar que Codemagic maneje los certificados

### Fase 4: Lanzar Build (20-30 minutos)

- [ ] **4.1** Iniciar build
  - En dashboard de Codemagic
  - Seleccionar workflow: **"ios-workflow"**
  - Clic en "Start new build"
  - Branch: **main**
  - Start build 🚀

- [ ] **4.2** Monitorear progreso
  - Ver logs en tiempo real
  - Esperar 15-25 minutos
  - Verificar que complete exitosamente

- [ ] **4.3** Build completado
  - ✅ Build successful
  - ✅ IPA generado
  - ✅ Subido a TestFlight automáticamente

### Fase 5: TestFlight (10-60 minutos)

- [ ] **5.1** Verificar en App Store Connect
  - Ir a: https://appstoreconnect.apple.com
  - My Apps → ForeverUs InLove → TestFlight
  - Ver build en "iOS builds"
  
- [ ] **5.2** Esperar revisión de Apple
  - Estado: "Processing" → "Waiting for Review"
  - Apple toma 10-60 minutos
  - Recibirás email cuando esté listo

- [ ] **5.3** Build aprobado
  - Estado: **"Ready to Test"** ✅
  - Ahora puedes agregar testers

### Fase 6: Agregar Testers (5 minutos)

- [ ] **6.1** Agregar Internal Testers
  - TestFlight → Internal Testing
  - Clic en "+" para agregar grupo
  - Nombre: "Internal Testers"
  - Agregar emails de testers (máx 100)

- [ ] **6.2** Testers reciben invitación
  - Email automático de Apple
  - Link para instalar TestFlight app
  - Link para instalar ForeverUs InLove

- [ ] **6.3** Testers instalan app
  - Descargar TestFlight desde App Store
  - Abrir email de invitación
  - Aceptar invitación
  - Instalar app
  - ¡Probar! 🎉

---

## 📊 VERIFICACIÓN FINAL

### Confirmar que todo funciona:

- [ ] Build completado en Codemagic sin errores
- [ ] App visible en App Store Connect
- [ ] Estado "Ready to Test" en TestFlight
- [ ] Testers pueden instalar la app
- [ ] App abre correctamente en iPhone
- [ ] Permisos funcionan (cámara, ubicación, etc.)
- [ ] Logo y diseño se ven correctos

---

## 🐛 TROUBLESHOOTING

### Problema: "No provisioning profile found"
- [ ] Activar "Automatic code signing" en Codemagic
- [ ] Verificar que API Key tenga permisos correctos

### Problema: "Bundle identifier mismatch"
- [ ] Verificar Bundle ID: `com.imagineapps.foreverusinlove`
- [ ] Actualizar en App Store Connect si es necesario

### Problema: "Build timeout"
- [ ] Aumentar `max_build_duration` en codemagic.yaml
- [ ] Cambiar a: `max_build_duration: 180`

### Problema: "Certificate expired"
- [ ] Renovar certificado en Apple Developer
- [ ] Actualizar en Codemagic code signing

---

## 💡 TIPS IMPORTANTES

✅ **El archivo .p8 solo se puede descargar UNA VEZ**
   → Guárdalo en un lugar seguro

✅ **Codemagic Free = 500 minutos/mes**
   → Cada build iOS = ~20 min
   → 25 builds al mes gratis

✅ **Apple revisa automáticamente cada build**
   → Puede tomar 10-60 minutos
   → Es normal, solo espera

✅ **Internal testers no necesitan revisión de Apple**
   → Pueden probar inmediatamente
   → External testers SÍ necesitan revisión (tarda días)

---

## 📞 SOPORTE

### Si tienes problemas:

1. **Codemagic Docs**: https://docs.codemagic.io/flutter-code-signing/ios-code-signing/
2. **Apple Developer Support**: https://developer.apple.com/contact/
3. **Ver logs del build** en Codemagic para errores específicos
4. **Revisar QUICK_IOS_SETUP.md** para pasos detallados
5. **Revisar IOS_BUILD_GUIDE.md** para guía completa

---

## ✨ ¡ÉXITO!

Si completaste todos los checkboxes:
- ✅ Tu app está en TestFlight
- ✅ Los testers pueden instalarla
- ✅ Puedes hacer builds desde Windows sin Mac
- ✅ Todo está automatizado

**¡Felicidades! 🎉**

---

**Última actualización:** 2025-10-24  
**Versión:** 1.0  
**Proyecto:** ForeverUs InLove iOS Build
