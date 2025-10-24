# 🚀 Setup Rápido: Build iOS desde Windows

## ⚡ LA FORMA MÁS RÁPIDA: Codemagic (15 minutos)

### 1️⃣ Crear Cuenta Apple Developer
- Ve a: https://developer.apple.com
- Paga $99/año para la membresía

### 2️⃣ Registrar en Codemagic
- Ve a: https://codemagic.io/start/
- Sign up con GitHub
- Conecta tu repo: `Luisnefelibato/Forever_Front`

### 3️⃣ Generar API Key de App Store Connect
1. Ve a: https://appstoreconnect.apple.com/access/api
2. Crea nueva API Key
3. **Descarga el archivo .p8** (solo se puede una vez!)
4. Guarda estos 3 valores:
   - **Issuer ID**
   - **Key ID**  
   - **Contenido del archivo .p8**

### 4️⃣ Configurar en Codemagic

En tu proyecto de Codemagic:

**Settings → Environment variables → Add variable:**

```
APP_STORE_CONNECT_ISSUER_ID = [tu Issuer ID]
APP_STORE_CONNECT_KEY_IDENTIFIER = [tu Key ID]
APP_STORE_CONNECT_PRIVATE_KEY = [contenido del .p8]
BUNDLE_ID = com.imagineapps.foreverusinlove
```

✅ Marcar todas como **"Secure"**

### 5️⃣ Activar Code Signing Automático

En Codemagic:
- **Settings → Code signing identities**
- Activar: **"Enable automatic code signing"**
- Codemagic generará los certificados por ti

### 6️⃣ Crear App en App Store Connect

1. Ve a: https://appstoreconnect.apple.com
2. **My Apps** → **"+"** → **"New App"**
3. Completa:
   - Platform: **iOS**
   - Name: **ForeverUs InLove**
   - Language: **Spanish**
   - Bundle ID: **com.imagineapps.foreverusinlove**
   - SKU: **foreverusinlove-ios**

### 7️⃣ Lanzar el Build

En Codemagic:
1. Selecciona workflow: **"ios-workflow"**
2. Clic en **"Start new build"**
3. Branch: **main**
4. **Start build** 🚀

### 8️⃣ Esperar (15-25 minutos) ☕

Codemagic hace TODO automáticamente:
- ✅ Compila la app
- ✅ Firma la app
- ✅ Genera el .ipa
- ✅ Sube a TestFlight

### 9️⃣ Verificar en TestFlight

1. Ve a: https://appstoreconnect.apple.com
2. **My Apps** → **ForeverUs InLove** → **TestFlight**
3. Espera 10-60 min para que Apple revise
4. Aparecerá como **"Ready to Test"** ✅

### 🔟 Agregar Testers

En TestFlight:
1. **Internal Testing** → **"+"**
2. Agrega emails de testers
3. Los testers reciben invitación
4. Instalan **TestFlight app** desde App Store
5. ¡Listo para probar! 🎉

---

## 🔑 Información Importante

### Bundle ID
```
com.imagineapps.foreverusinlove
```

### Display Name
```
Forever Us In Love
```

### Version Inicial
```
1.0.0 (Build 1)
```

---

## 🆘 Problemas Comunes

### ❌ "No provisioning profile found"
✅ Activa "Automatic code signing" en Codemagic

### ❌ "Invalid Bundle ID"
✅ Verifica que sea exactamente: `com.imagineapps.foreverusinlove`

### ❌ "Build timeout"
✅ Aumenta `max_build_duration` en `codemagic.yaml`

---

## 💰 Costos

| Servicio | Costo |
|----------|-------|
| Apple Developer | $99/año (obligatorio) |
| Codemagic Free | $0 (500 min/mes) |
| Codemagic Pro | $59/mes (opcional) |

---

## 📚 Archivos Importantes del Proyecto

✅ Ya están listos en el repo:

- `codemagic.yaml` - Configuración de Codemagic
- `ios/Runner/Info.plist` - Permisos y configuración iOS
- `ios/ExportOptions.plist` - Opciones de exportación
- `.github/workflows/ios-build.yml` - Alternativa con GitHub Actions

---

## 🎯 Checklist Antes del Build

- [ ] Apple Developer Account activo ($99 pagados)
- [ ] App creada en App Store Connect
- [ ] API Key de App Store Connect generada
- [ ] Secrets configurados en Codemagic
- [ ] Code signing automático activado
- [ ] Código en GitHub (branch main)

---

## 📞 Enlaces Útiles

- **Codemagic:** https://codemagic.io
- **App Store Connect:** https://appstoreconnect.apple.com
- **Apple Developer:** https://developer.apple.com
- **Docs Codemagic iOS:** https://docs.codemagic.io/flutter-code-signing/ios-code-signing/

---

**¡Con estos pasos deberías tener tu app en TestFlight en menos de 30 minutos!** 🚀

Para más detalles, ver: `IOS_BUILD_GUIDE.md`
