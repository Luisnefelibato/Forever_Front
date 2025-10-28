# ForeverUsInLove API Endpoint Testing Suite - PowerShell Version
# Testing all 21 Authentication Endpoints

$BASE_URL = "http://3.232.35.26:8000/api/v1"
$TOKEN = ""
$SESSION_ID = ""
$DEVICE_ID = ""

Write-Host "ForeverUsInLove API Endpoint Testing Suite" -ForegroundColor Blue
Write-Host "Base URL: $BASE_URL" -ForegroundColor Blue
Write-Host ""

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

# Function to test endpoint
function Test-Endpoint {
    param($Name, $Method, $Uri, $Body = $null, $Headers = @{})
    
    Write-Host ""
    Write-Host "Testing: $Name" -ForegroundColor Yellow
    Write-Host "$Method $Uri" -ForegroundColor Cyan
    
    try {
        $params = @{
            Uri = $Uri
            Method = $Method
            Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        Write-Host "SUCCESS: Status OK" -ForegroundColor Green
        Write-Host "Response:" -ForegroundColor Blue
        $response | ConvertTo-Json -Depth 5
        
        # Extract token if present
        if ($response.token) {
            $script:TOKEN = $response.token
            Write-Host "Token extracted for future requests" -ForegroundColor Green
        }
        
        # Extract session info if present
        if ($response.session_id) {
            $script:SESSION_ID = $response.session_id
            Write-Host "Session ID extracted: $SESSION_ID" -ForegroundColor Green
        }
        
        if ($response.device_id) {
            $script:DEVICE_ID = $response.device_id
            Write-Host "Device ID extracted: $DEVICE_ID" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
}

# ============================================================================
# LOGIN & LOGOUT ENDPOINTS (6 endpoints)
# ============================================================================

Write-Host "LOGIN & LOGOUT ENDPOINTS (6 endpoints)" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta

Test-Endpoint "Login with Email" "POST" "$BASE_URL/auth/login" (@{
    login = $RANDOM_EMAIL
    password = $PASSWORD
    remember = $true
} | ConvertTo-Json)

Test-Endpoint "Login with Phone" "POST" "$BASE_URL/auth/login" (@{
    login = $RANDOM_PHONE
    password = $PASSWORD
    remember = $true
} | ConvertTo-Json)

Test-Endpoint "Login with Username" "POST" "$BASE_URL/auth/login" (@{
    login = "testuser"
    password = $PASSWORD
    remember = $true
} | ConvertTo-Json)

Test-Endpoint "Logout Current Session" "POST" "$BASE_URL/auth/logout" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Logout All Sessions" "POST" "$BASE_URL/auth/logout/all-devices" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Logout Specific Device" "POST" "$BASE_URL/auth/logout/device/test-device-123" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "List Active Sessions" "GET" "$BASE_URL/auth/sessions" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Delete Session" "DELETE" "$BASE_URL/auth/sessions/test-session-123" $null @{"Authorization"="Bearer $TOKEN"}

# ============================================================================
# REGISTRATION ENDPOINTS (3 endpoints)
# ============================================================================

Write-Host ""
Write-Host "REGISTRATION ENDPOINTS (3 endpoints)" -ForegroundColor Magenta
Write-Host "====================================" -ForegroundColor Magenta

Test-Endpoint "Simple Registration" "POST" "$BASE_URL/auth/register/simple-register" (@{
    email = $RANDOM_EMAIL
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "Test"
    last_name = "User"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json)

Test-Endpoint "Register + Email Verification" "POST" "$BASE_URL/auth/register/with-email-verification" (@{
    email = "test_email_verify_$timestamp@example.com"
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "TestEmail"
    last_name = "Verify"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json)

Test-Endpoint "Register + Phone Verification" "POST" "$BASE_URL/auth/register/with-phone-verification" (@{
    phone = "+1555$((Get-Random -Minimum 1000000 -Maximum 9999999))"
    password = $PASSWORD
    password_confirmation = $PASSWORD
    first_name = "TestPhone"
    last_name = "Verify"
    date_of_birth = "1995-05-15"
} | ConvertTo-Json)

# ============================================================================
# VERIFICATION ENDPOINTS (7 endpoints)
# ============================================================================

Write-Host ""
Write-Host "VERIFICATION ENDPOINTS (7 endpoints)" -ForegroundColor Magenta
Write-Host "====================================" -ForegroundColor Magenta

Test-Endpoint "Send Email Verification Code" "POST" "$BASE_URL/auth/verification/email/send" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Verify Email Code" "POST" "$BASE_URL/auth/verification/email/verify" (@{
    code = "123456"
} | ConvertTo-Json) @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Resend Email Code" "POST" "$BASE_URL/auth/verification/email/resend" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Check Email Status" "GET" "$BASE_URL/auth/verification/email/status" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Send Phone Verification Code" "POST" "$BASE_URL/auth/verification/phone/send" $null @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Verify Phone Code" "POST" "$BASE_URL/auth/verification/phone/verify" (@{
    code = "123456"
} | ConvertTo-Json) @{"Authorization"="Bearer $TOKEN"}

Test-Endpoint "Resend Phone Code" "POST" "$BASE_URL/auth/verification/phone/resend" $null @{"Authorization"="Bearer $TOKEN"}

# ============================================================================
# PASSWORD MANAGEMENT ENDPOINTS (3 endpoints)
# ============================================================================

Write-Host ""
Write-Host "PASSWORD MANAGEMENT ENDPOINTS (3 endpoints)" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

Test-Endpoint "Request Password Reset" "POST" "$BASE_URL/auth/password/forgot" (@{
    identifier = $RANDOM_EMAIL
} | ConvertTo-Json)

Test-Endpoint "Reset Password with Token" "POST" "$BASE_URL/auth/password/reset" (@{
    identifier = $RANDOM_EMAIL
    code = "123456"
    password = "NewPassword123!"
    password_confirmation = "NewPassword123!"
} | ConvertTo-Json)

Test-Endpoint "Change Password (Authenticated)" "PUT" "$BASE_URL/auth/password/change" (@{
    current_password = $PASSWORD
    new_password = "UpdatedPassword123!"
    new_password_confirmation = "UpdatedPassword123!"
} | ConvertTo-Json) @{"Authorization"="Bearer $TOKEN"}

# ============================================================================
# SOCIAL AUTHENTICATION ENDPOINTS (2 endpoints)
# ============================================================================

Write-Host ""
Write-Host "SOCIAL AUTHENTICATION ENDPOINTS (2 endpoints)" -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta

Test-Endpoint "Google OAuth Login/Register" "POST" "$BASE_URL/auth/social/google" (@{
    token = "fake_google_token_for_testing"
} | ConvertTo-Json)

Test-Endpoint "Apple OAuth Login/Register" "POST" "$BASE_URL/auth/social/apple" (@{
    token = "fake_apple_token_for_testing"
} | ConvertTo-Json)

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host ""
Write-Host "TESTING COMPLETE" -ForegroundColor Blue
Write-Host "================" -ForegroundColor Blue
Write-Host "Total Endpoints Tested: 21" -ForegroundColor Green
Write-Host "Login & Logout: 6 endpoints" -ForegroundColor Green
Write-Host "Registration: 3 endpoints" -ForegroundColor Green
Write-Host "Verification: 7 endpoints" -ForegroundColor Green
Write-Host "Password Management: 3 endpoints" -ForegroundColor Green
Write-Host "Social Authentication: 2 endpoints" -ForegroundColor Green
Write-Host ""
Write-Host "Review the output above for detailed results." -ForegroundColor Yellow
