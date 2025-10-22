# 📖 User Stories - ForeverUsInLove

## Module: Authentication (Auth)

---

## HU_001: App Identification Elements

### 📋 User Story
**As a user** of the app, I must be able to identify ForeverUSinlove within my applications.

### Priority
⭐⭐⭐ High

### Acceptance Criteria

#### Happy Path

1. **Splash Screen Display**
   - App displays custom logo on launch
   - Logo must be synergistic with favicon (if parallel website exists)
   - Application name is visible and starts with capital letter
   - Smooth transition from splash screen to welcome screen

2. **Welcome Screen**
   - User sees welcome screen with options:
     - Login
     - Create Account
     - Change Password

3. **Permission Requests**
   - App requests access to:
     - ✅ Notifications
     - ✅ Camera
     - ✅ Location

#### Design Details
- Connection error message when no internet
- Splash screen must be responsive across different device sizes
- Clean transition without size or proportion changes
- Screen rotation is locked (portrait only)

#### Error Handling

1. **Permission Denied**
   - **Notifications screen**: "Verifica tus permisos."
   - **Camera screen**: Request permissions when accessing FaceID or gallery upload
   - **Location screen**: Disable zone filter (ft or km)

2. **No Internet Connection**
   - If check starts from splash screen
   - Message: "¡Ups! Something was wrong. Check your conexión."

3. **Screen Orientation**
   - App must not allow native phone rotation

---

## HU_002: Create Account

### 📋 User Story
**As a user** of the app, I want to register on the platform to access all marketplace functionalities.

### Priority
⭐⭐⭐ High

### Acceptance Criteria

#### Happy Path

### **Step 1: Personal Information** (Progress: 1/6)

**Form Fields:**

| Field | Type | Length | Options | Required |
|-------|------|--------|---------|----------|
| Name(s) | Alphanumeric | Max 25 chars | - | ✅ |
| Surname(s) | Alphanumeric | Max 25 chars | - | ✅ |
| Phone Number | Numeric | Max 10 chars | Colombian format | ✅ |
| Email | Email | Max 100 chars | Valid email | ✅ |
| Date of Birth | Date | Max 8 chars | DD/MM/YYYY | ✅ |
| Gender | Radio | - | Man, Woman, No Binari | ✅ |
| Interests | Radio | - | Man, Woman, Man and Woman | ✅ |
| Password | Alphanumeric | Max 25 chars | - | ✅ |
| Confirm Password | Alphanumeric | Max 25 chars | Must match | ✅ |

**Additional Requirements:**
- Password toggle visibility (eye icon)
- All fields are mandatory
- "Continue" button enabled when all fields complete
- Links to "Terms and Conditions" and "Privacy Policy"
- Checkbox for terms acceptance (required)

**Password Requirements:**
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- No special characters required (for elderly accessibility)

---

### **Step 2: OTP Verification** (Progress: 2/6)

**Requirements:**

1. **Code Delivery**
   - User receives 4-digit code via SMS/OTP to registered phone
   - Code sent to registered email (alternative)
   - Code valid for 10 minutes
   - Message template: "¡Hola! Tu código de verificación en ForeverUSinlove es: {code}"

2. **Code Input**
   - Form field: Numeric, 4 characters
   - "Resend Code" button available after 30 seconds
   - Countdown timer: "Podrás reenviar el código en 30 s."

3. **Code Resend**
   - SMS success message: "Te hemos enviado un nuevo código de validación por SMS/OTP"
   - Email success message: "Te hemos enviado un nuevo correo de validación"
   - Only most recent code is valid

4. **Success**
   - If validation successful, enable "Create Account" button
   - User redirected to ForeverUSinlove home
   - Success confirmation message

**Important Notes:**
- If user abandons process at this step, they must restart from Step 1
- Account is not created until OTP verification completes

---

### **Step 3: Face ID Verification** (Progress: 3/6) - OPTIONAL

**Requirements:**

1. **Skip Option**
   - "Skip" button available
   - Warning modal about consequences of skipping
   - Modal buttons: "Cancel", "Continue"

2. **Face Capture Process**
   - Guided flow with active camera
   - Automatic face capture
   - System validates match with document data
   - Clear progress indicator: "1/3 Capture face"

3. **Capture Guidelines**
   - Maintain camera centered on user's face
   - Oval or guide frame for correct positioning
   - Retry option for poor lighting, blur, or excessive movement

4. **Feedback**
   - Success/error messages inform operation status
   - "Continue" option enabled when Face ID correct

**Technical Validations:**
- Face detection (human face recognized)
- Frame alignment (face within guide)
- Image quality (lighting, focus, movement)

---

### **Step 4: Document Verification** (Progress: 4/6) - OPTIONAL

**Requirements:**

1. **Skip Option**
   - "Skip" button available
   - Warning modal about verification consequences
   - Modal buttons: "Cancel", "Continue"

2. **Document Upload**
   - Upload or real-time capture of ID photos (front & back)
   - Automatic validations: clarity, size, orientation
   - Progress indicator: "2/3 Front of document", "3/3 Back of document"

3. **Validations**
   - Block progress if no human face detected
   - Block if photos don't meet minimum legibility
   - Prevent duplicate side uploads
   - Verify data matches account registration

4. **User Experience**
   - Neutral colors and short empathetic error messages
   - Clear iconography differentiating Face ID from document steps
   - Alert for interruptions during camera capture

5. **Security**
   - Register and handle camera errors (permissions denied, unavailable, timeout)
   - Alternative flow for retry or support contact
   - No local image storage without encryption
   - All captures sent via secure channel (HTTPS)

6. **Feedback**
   - Success/error messages
   - "Continue" enabled when ID verification correct
   - Image preview option
   - Retake capture/photo option

---

### **Step 5: Upload Images** (Progress: 5/6)

**Requirements:**

1. **Verification Skip Consequence**
   - If user skipped identity verification
   - Alert message: Must verify identity to upload photos
   - Modal options: Cancel or return to identity verification
   - Cancel redirects to personality survey

2. **Image Upload**
   - Minimum: 2 images
   - Maximum: 6 images
   - Simultaneous upload supported
   - Accepted formats: .jpg, .jpeg, .png, .webp
   - Max size: 5 MB per image

3. **Validations**
   - Compare uploaded photos with FaceID resource
   - Verify identity match
   - Block progression with less than 2 verified images

4. **User Interface**
   - Preview each loaded image before saving
   - Delete option for loaded images
   - Maintain loading order (first = main image)
   - Drag & drop or arrow reordering
   - Visual confirmation on successful/failed upload

---

### **Step 6: Personality Onboarding** (Progress: 6/6)

**Requirements:**

1. **Survey Introduction**
   - Dedicated screen with title, description, total questions
   - Skip option (page 1) with warning about reduced synergy
   - Modal buttons: "Cancel", "Continue"

2. **Survey Flow**
   - Progress bar updates as user advances
   - Questions in logical order
   - Visible "Next" and "Previous" buttons
   - Various field types:
     - Free text
     - Numeric
     - Multiple choice (checkbox)
     - Single choice (radio)
     - Dropdown lists

3. **Data Management**
   - Validate mandatory questions before advancing
   - Real-time progress save (prevent data loss)
   - Summary screen showing all answers
   - "Finish Onboarding" option when all mandatory data complete

4. **Completion**
   - Success message on correct process
   - Redirect to home

---

#### Design Details

**General:**
- Button activates when mandatory fields complete
- Password visibility toggle icon
- Red error messages below fields, green success messages
- Responsive design for mobile devices
- Field text design matches length limits
- Action button prominently colored (especially for elderly users)

**Character Limits:**
- Display character limit on text fields
- Real-time counter display

**Validation Messages:**
- Clear, specific error messages
- Confirmation messages for successful actions

---

#### Error Handling

**Step 1: Personal Information**

| Error | Message |
|-------|---------|
| Empty field | "Este campo es obligatorio." |
| Under 18 years | "Se requiere ser mayor de 18 años." |
| Invalid phone format | "El número no es válido." |
| Invalid email format | "El correo no es válido." |
| Password mismatch | "Las contraseñas no coinciden." |
| Weak password | Password requirements text in red |
| Phone already registered | "El número ya se encuentra registrado"* |
| Account creation error | "¡Ups! Se presentó un error al realizar esta acción, inténtalo de nuevo." |

*Note: If user didn't complete OTP, phone should not be considered registered

**Step 2: OTP Verification**

| Error | Message |
|-------|---------|
| Incorrect/incomplete code | "El código no es válido" |
| Expired code | "El código ha expirado. Inténtalo de nuevo." |
| Send error | "Hubo un error al enviar tu código de verificación. Por favor, inténtalo más tarde." |
| Invalid code | "Código inválido" |

**Step 3 & 4: Identity Verification**

**Face ID Errors:**
- Connection failure or timeout
- Face detection failed (no human face or out of frame)
- Failed match between captured face and ID photo (low similarity)

**Document Upload Errors:**
- Blurry photo, poor lighting, movement
- Illegible document (reflections, incorrect focus, low resolution)
- Inverted, cropped, or text outside frame
- Duplicate upload of same side
- Unsupported file format or size too large
- Server processing/validation error
- Failed automatic data reading (name, number, birth date)
- Flow desynchronization (user advances without completing step)
- Process interruption (app closure, connection loss)
- Biometric comparison error (expression/accessory differences)
- Excessive validation time causing user abandonment
- Visual component loading failure or interface block
- Device orientation issues misaligning face/document
- External validation service communication error
- User attempts verification with different document than registered
- Security failure in encryption or sending if HTTPS not applied

**Step 5: Image Upload**

| Error | Message |
|-------|---------|
| Non-image file | "Formato no permitido. Solo se aceptan .jpg, .jpeg, .png y .webp". |
| Oversized image (>5MB) | "El archivo excede el peso máximo permitido (5 MB)". |
| More than 6 images | "Solo se pueden subir hasta 6 imágenes". |
| Failed Face ID verification | Alert user |
| Connection loss during upload | Error message with retry option |
| Less than 2 images | "Debes cargar al menos dos imagenes". |

**Step 6: Personality Survey**

| Error | Solution |
|-------|----------|
| Network error during survey | Offer automatic recovery flow |
| Invalid values in numeric fields | Alert user |
| Character limit exceeded | Display error message |
| Multiple submit attempts | Prevent duplicate submissions |
| Server failure | Clear, empathetic error message |
| Accidental exit | Exit confirmation to prevent data loss |
| Data privacy | Send responses encrypted |
| Device compatibility | Ensure visual/functional compatibility |

**General Requirements:**
- All popups must have close option (X button)
- Numeric fields must not allow commas, periods, or hyphens (especially Android)
- Deleted account users see same message as unregistered emails

---

## HU_003: Identity Verification

### 📋 User Story
**As a user** of ForeverUSinlove, I want to verify my identity through facial recognition (Face ID) and photos of my ID (both sides) to guarantee account authenticity and platform security.

### Priority
⭐⭐⭐ High

### Technical Requirements
See Step 3 and Step 4 in HU_002 above.

---

## HU_004: Upload Images

### 📋 User Story
**As a user** of the app, I want to upload images when creating my profile that are validated by identity verification systems.

### Priority
⭐⭐⭐ High

### Technical Requirements
See Step 5 in HU_002 above.

---

## HU_005: Personality Onboarding

### 📋 User Story
**As a user** of the app, I must be able to answer personality questionnaires with different question types (text, number, multiple choice, single choice, dropdowns) so the system can analyze my responses and offer personalized results or matches based on my profile.

### Priority
⭐⭐⭐ High

### Technical Requirements
See Step 6 in HU_002 above.

---

## HU_006: Login

### 📋 User Story
**As a registered user**, I want to log in to the application easily and securely to access my account and manage my data.

### Priority
⭐⭐⭐ High

### Acceptance Criteria

#### Happy Path

1. **Login Options**
   - User accesses login screen via:
     - "Continue with phone number"
     - "Continue with email"

2. **Login Form**
   - Based on selection, display form with 2 mandatory fields:
     - Phone Number / Email
     - Password

**Field Specifications:**

| Field | Type | Length |
|-------|------|--------|
| Phone Number | Numeric | Max 10 chars (Colombian format) |
| Email | Email | Max 100 chars |
| Password | Alphanumeric | Max 25 chars |

3. **Password Visibility**
   - Toggle password visibility with eye icon

4. **Form Validation**
   - All fields mandatory
   - Action button enabled when fields complete
   - If correct, user routed to ForeverUSinlove home
   - User name displayed in account module

5. **Social Login Options**
   - **Google Sign-In** option
   - **Facebook Login** option
   - Upon account selection, user routed to their session
   - If no account exists, route to personal information (Step 1 of registration)

6. **Remember Me**
   - Checkbox option to save login information post-registration

#### Design Details

- Responsive mobile design
- "Forgot your password?" link below form
- "Create account" link for users without account
- Text contained within defined fields

#### Error Handling

| Error | Message |
|-------|---------|
| Empty field | "Este campo es obligatorio". |
| Invalid phone/password | "El número de celular y/o la contraseña no son válidos".* |
| Google/Facebook login failure | "¡Ups! Al parecer no se ha podido realizar esta acción. Intenta más tarde." |
| Auto-login with "Remember Me" fails | "¡Ups! No logramos acceder a tu cuenta. Inténtalo de nuevo más tarde o ha Log In nuevamente". |
| Profile access error | "¡Ups! Se presentó un error al realizar esta acción, inténtalo de nuevo." |

*Note: Message applies to invalid phones and unregistered phones (including users who didn't complete OTP)

**Special Cases:**
- Deleted users can create new account and login with same phone
- Numeric fields must not allow commas, periods, or hyphens (especially Android)

---

## HU_007: Password Recovery

### 📋 User Story
**As a registered user**, I want to recover my password if I forget it to restore access to the application.

### Priority
⭐⭐⭐ High

### Acceptance Criteria

#### Happy Path

**Access:**
- From "Forgot your password?" link on login screen

---

### **Step 1: Identification**

**Form Fields:**

| Field | Type | Length |
|-------|------|--------|
| Phone Number | Numeric | Max 10 chars (Colombian format) |
| Email | Email | Max 100 chars |

- All fields mandatory
- "Continue" button enabled when complete

---

### **Step 2: OTP Verification**

1. **System Validation**
   - Validate phone/email is registered
   - Continue to code entry screen
   - *Note: Users who didn't complete OTP registration treated as unregistered*

2. **Code Delivery**
   - 4-digit code sent to phone or email
   - Message indicates ForeverUSinlove origin
   - Code valid for 10 minutes

3. **Code Entry**
   - Input field for 4-digit code
   - If correct, redirect to new password screen

---

### **Step 3: New Password**

**Form Fields:**

| Field | Type | Length |
|-------|------|--------|
| Password | Alphanumeric | Max 25 chars |
| Confirm Password | Alphanumeric | Max 25 chars |

**Requirements:**
- Password visibility toggle (eye icon)
- All fields mandatory
- "Reset Password" button enabled when complete
- Success message: "Tu contraseña ha sido restablecida con éxito, ya puedes iniciar sesión nuevamente."

---

### **Step 4: Return to Login**

- Click "Log In" button
- User redirected to login screen

---

#### Additional Features

**Code Resend:**
- Minimum 30-second wait for "Resend Code" button
- Success message: "Te hemos enviado un nuevo código de validación por SMS"
- Validate with most recent code only (invalidate previous)

#### Design Details

- Responsive mobile design
- Button activates when all mandatory fields complete
- Password requirements info message

#### Error Handling

| Error | Message |
|-------|---------|
| Empty field (phone/email/code/password) | "Este campo es obligatorio." |
| Invalid phone format | "El número no es válido" |
| Invalid email format | "El correo no es válido" |
| Unregistered phone* | "El Número no es válido". |
| Unregistered email* | "El correo no es válido". |
| Password recovery error | "¡Ups!Se presentó un error al realizar esta acción, inténtalo de nuevo." |
| Code send error | "Se presentó un error al realizar esta acción, inténtalo de nuevo." |
| Expired code | "El código no es válido" |
| Incorrect/incomplete code | "El código no es válido" |
| Password doesn't meet requirements | Requirement text highlighted in red |
| Passwords don't match | "Las contraseñas no coinciden." |

*Note: Applies to users who didn't complete OTP registration

**Special Cases:**
- All popups must have close option (X button)
- Numeric fields must not allow commas, periods, or hyphens (Android)
- "Remember me" field unchecked after password recovery
- Users who lose phone number must contact ForeverUSinlove administrator

---

## Summary

### Module: Authentication (7 User Stories)

| ID | Name | Priority | Status |
|----|------|----------|--------|
| HU_001 | App Identification Elements | High | 📋 Documented |
| HU_002 | Create Account | High | 📋 Documented |
| HU_003 | Identity Verification | High | 📋 Documented |
| HU_004 | Upload Images | High | 📋 Documented |
| HU_005 | Personality Onboarding | High | 📋 Documented |
| HU_006 | Login | High | 📋 Documented |
| HU_007 | Password Recovery | High | 📋 Documented |

---

### Implementation Status

- ✅ Architecture Defined
- ✅ Documentation Complete
- ⏳ UI/UX Design Pending Approval
- ⏳ Implementation Pending
- ⏳ Testing Pending
- ⏳ Deployment Pending

---

## Next Steps

1. **Design Phase**
   - Create wireframes for all screens
   - Design UI components
   - Create design system
   - Get stakeholder approval

2. **Implementation Phase**
   - Set up feature modules
   - Implement BLoC for each flow
   - Create UI screens
   - Integrate with backend API
   - Implement AWS services

3. **Testing Phase**
   - Unit tests for business logic
   - Widget tests for UI
   - Integration tests for flows
   - User acceptance testing

4. **Deployment**
   - Beta testing
   - Production deployment
   - Monitoring and analytics

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Based On:** ForeverUSinlove Auth Module Specification PDF
