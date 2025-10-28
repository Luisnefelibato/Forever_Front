# ForeverUsInLove API Endpoint Testing Suite - PowerShell Version

$BASE_URL = "http://3.232.35.26:8000/api/v1"
$TOKEN = ""
$SESSION_ID = ""
$DEVICE_ID = ""

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║     ForeverUsInLove API Endpoint Testing Suite            ║" -ForegroundColor Blue
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "Base URL: $BASE_URL" -ForegroundColor Blue
Write-Host ""

# Function to print test header
function Print-Test {
    param($TestName)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host "TEST: $TestName" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
}

# Function to print success
function Print-Success {
    param($Message)
    Write-Host "✓ SUCCESS: $Message" -ForegroundColor Green
}

# Function to print error
function Print-Error {
    param($Message)
    Write-Host "✗ FAILED: $Message" -ForegroundColor Red
}

# Function to print response
function Print-Response {
    param($Response)
    Write-Host "Response:" -ForegroundColor Blue
    try {
        $jsonResponse = $Response | ConvertFrom-Json
        $Response | ConvertFrom-Json | ConvertTo-Json -Depth 10
    } catch {
        Write-Host $Response
    }
}

# Generate random credentials
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$RANDOM_EMAIL = "test_$timestamp@example.com"
$RANDOM_PHONE = "+1555$((Get-Random -Minimum 1000000 -Maximum 9999999))"
$PASSWORD = "TestPassword123!"

Write-Host "Test User Credentials:" -ForegroundColor Blue
Write-Host "Email: $RANDOM_EMAIL"
Write-Host "Phone: $RANDOM_PHONE"
Write-Host "Password: $PASSWORD"
Write-Host ""

# ============================================================================
# REGISTRATION ENDPOINTS (3)
# ============================================================================

Print-Test "1.1 POST /auth/register/simple-register - Simple Registration"
$body = @{
    email = $RANDOM_EMAIL
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "Test"
    last_name = "User"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/register/simple-register" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    if ($response.token) {
        $TOKEN = $response.token
        Print-Success "Registration successful"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } else {
        Print-Error "Registration failed"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    }
} catch {
    Print-Error "Registration failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "1.2 POST /auth/register/with-email-verification - Register with Email Verification"
$EMAIL_VERIFY = "test_email_verify_$timestamp@example.com"
$body = @{
    email = $EMAIL_VERIFY
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "TestEmail"
    last_name = "Verify"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/register/with-email-verification" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Email verification registration failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "1.3 POST /auth/register/with-phone-verification - Register with Phone Verification"
$PHONE_VERIFY = "+1555$((Get-Random -Minimum 1000000 -Maximum 9999999))"
$body = @{
    phone = $PHONE_VERIFY
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "TestPhone"
    last_name = "Verify"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/register/with-phone-verification" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Phone verification registration failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# ============================================================================
# LOGIN & LOGOUT ENDPOINTS (6)
# ============================================================================

Print-Test "2.1 POST /auth/login - Login with Email"
$body = @{
    login = $RANDOM_EMAIL
    password = $PASSWORD
    remember = $true
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    if ($response.token) {
        $TOKEN = $response.token
        Print-Success "Login successful - Token obtained"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } else {
        Print-Error "Login failed"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    }
} catch {
    Print-Error "Login failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "2.2 GET /auth/sessions - List Active Sessions"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/sessions" -Method GET -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    if ($response.sessions) {
        Print-Success "Sessions retrieved"
        if ($response.sessions.Count -gt 0) {
            $SESSION_ID = $response.sessions[0].id
            $DEVICE_ID = $response.sessions[0].device_id
        }
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } else {
        Print-Error "Failed to retrieve sessions"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    }
} catch {
    Print-Error "Failed to retrieve sessions: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "2.3 POST /auth/logout/device/{device_id} - Logout Specific Device"
if ($DEVICE_ID) {
    try {
        $response = Invoke-RestMethod -Uri "$BASE_URL/auth/logout/device/$DEVICE_ID" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } catch {
        Print-Error "Device logout failed: $($_.Exception.Message)"
        Print-Response $_.Exception.Response
    }
} else {
    Print-Error "No device_id available to test"
}

Print-Test "2.4 DELETE /auth/sessions/{session_id} - Delete Session"
if ($SESSION_ID) {
    try {
        $response = Invoke-RestMethod -Uri "$BASE_URL/auth/sessions/$SESSION_ID" -Method DELETE -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } catch {
        Print-Error "Session deletion failed: $($_.Exception.Message)"
        Print-Response $_.Exception.Response
    }
} else {
    Print-Error "No session_id available to test"
}

# Login again for remaining tests
try {
    $body = @{
        login = $RANDOM_EMAIL
        password = $PASSWORD
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body $body -ContentType "application/json"
    $TOKEN = $response.token
} catch {
    Write-Host "Failed to re-login for remaining tests" -ForegroundColor Red
}

Print-Test "2.5 POST /auth/logout/all-devices - Logout All Devices"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/logout/all-devices" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "All devices logout failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# Login again for remaining tests
try {
    $body = @{
        login = $RANDOM_EMAIL
        password = $PASSWORD
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body $body -ContentType "application/json"
    $TOKEN = $response.token
} catch {
    Write-Host "Failed to re-login for remaining tests" -ForegroundColor Red
}

Print-Test "2.6 POST /auth/logout - Logout Current Session"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/logout" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    if ($response.message) {
        Print-Success "Logout successful"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    } else {
        Print-Error "Logout failed"
        Print-Response ($response | ConvertTo-Json -Depth 10)
    }
} catch {
    Print-Error "Logout failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# Login again for verification tests
try {
    $body = @{
        login = $RANDOM_EMAIL
        password = $PASSWORD
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body $body -ContentType "application/json"
    $TOKEN = $response.token
} catch {
    Write-Host "Failed to re-login for verification tests" -ForegroundColor Red
}

# ============================================================================
# EMAIL VERIFICATION ENDPOINTS (4)
# ============================================================================

Print-Test "3.1 POST /auth/verification/email/send - Send Email Verification Code"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/email/send" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Email verification send failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "3.2 GET /auth/verification/email/status - Check Email Status"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/email/status" -Method GET -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Email status check failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "3.3 POST /auth/verification/email/resend - Resend Email Code"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/email/resend" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Email resend failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "3.4 POST /auth/verification/email/verify - Verify Email Code"
$body = @{
    code = "123456"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/email/verify" -Method POST -Body $body -ContentType "application/json" -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Email verification failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# ============================================================================
# PHONE VERIFICATION ENDPOINTS (3)
# ============================================================================

Print-Test "4.1 POST /auth/verification/phone/send - Send Phone Verification Code"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/phone/send" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Phone verification send failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "4.2 POST /auth/verification/phone/resend - Resend Phone Code"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/phone/resend" -Method POST -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Phone resend failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "4.3 POST /auth/verification/phone/verify - Verify Phone Code"
$body = @{
    code = "123456"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/verification/phone/verify" -Method POST -Body $body -ContentType "application/json" -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Phone verification failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# ============================================================================
# PASSWORD MANAGEMENT ENDPOINTS (3)
# ============================================================================

Print-Test "5.1 POST /auth/password/forgot - Request Password Reset"
$body = @{
    identifier = $RANDOM_EMAIL
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/password/forgot" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Password forgot failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "5.2 POST /auth/password/reset - Reset Password with Token"
$body = @{
    identifier = $RANDOM_EMAIL
    code = "123456"
    password = "NewPassword123!"
    password_confirmation = "NewPassword123!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/password/reset" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Password reset failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "5.3 PUT /auth/password/change - Change Password (Authenticated)"
$body = @{
    current_password = $PASSWORD
    new_password = "UpdatedPassword123!"
    new_password_confirmation = "UpdatedPassword123!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/password/change" -Method PUT -Body $body -ContentType "application/json" -Headers @{"Authorization"="Bearer $TOKEN"; "Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Password change failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# ============================================================================
# SOCIAL AUTHENTICATION ENDPOINTS (2)
# ============================================================================

Print-Test "6.1 POST /auth/social/google - Google OAuth Login"
$body = @{
    token = "fake_google_token_for_testing"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/social/google" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Google OAuth failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

Print-Test "6.2 POST /auth/social/apple - Apple OAuth Login"
$body = @{
    token = "fake_apple_token_for_testing"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/auth/social/apple" -Method POST -Body $body -ContentType "application/json" -Headers @{"Accept"="application/json"}
    Print-Response ($response | ConvertTo-Json -Depth 10)
} catch {
    Print-Error "Apple OAuth failed: $($_.Exception.Message)"
    Print-Response $_.Exception.Response
}

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║                    TESTING COMPLETE                        ║" -ForegroundColor Blue
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "All 21 endpoints have been tested." -ForegroundColor Green
Write-Host "Review the output above for detailed results." -ForegroundColor Yellow
Write-Host ""
