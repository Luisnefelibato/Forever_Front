#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

BASE_URL="http://3.232.35.26:8000/api/v1"
TOKEN=""
SESSION_ID=""
DEVICE_ID=""

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ForeverUsInLove API Endpoint Testing Suite            ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}Base URL: ${BASE_URL}${NC}\n"

# Function to print test header
print_test() {
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}TEST: $1${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ SUCCESS: $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ FAILED: $1${NC}"
}

# Function to print response
print_response() {
    echo -e "${BLUE}Response:${NC}"
    echo "$1" | jq '.' 2>/dev/null || echo "$1"
}

# Generate random email
RANDOM_EMAIL="test_$(date +%s)@example.com"
RANDOM_PHONE="+1555$(shuf -i 1000000-9999999 -n 1)"
PASSWORD="TestPassword123!"

echo -e "${BLUE}Test User Credentials:${NC}"
echo -e "Email: ${RANDOM_EMAIL}"
echo -e "Phone: ${RANDOM_PHONE}"
echo -e "Password: ${PASSWORD}\n"

# ============================================================================
# REGISTRATION ENDPOINTS (3)
# ============================================================================

print_test "1.1 POST /auth/register/simple-register - Simple Registration"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register/simple-register" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"email\": \"${RANDOM_EMAIL}\",
    \"password\": \"${PASSWORD}\",
    \"password_confirmation\": \"${PASSWORD}\",
    \"first_name\": \"Test\",
    \"last_name\": \"User\",
    \"date_of_birth\": \"1995-05-15\"
  }")

if echo "$RESPONSE" | jq -e '.token' > /dev/null 2>&1; then
    TOKEN=$(echo "$RESPONSE" | jq -r '.token')
    print_success "Registration successful"
    print_response "$RESPONSE"
else
    print_error "Registration failed"
    print_response "$RESPONSE"
fi

print_test "1.2 POST /auth/register/with-email-verification - Register with Email Verification"
EMAIL_VERIFY="test_email_verify_$(date +%s)@example.com"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register/with-email-verification" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"email\": \"${EMAIL_VERIFY}\",
    \"password\": \"${PASSWORD}\",
    \"password_confirmation\": \"${PASSWORD}\",
    \"first_name\": \"TestEmail\",
    \"last_name\": \"Verify\",
    \"date_of_birth\": \"1995-05-15\"
  }")

print_response "$RESPONSE"

print_test "1.3 POST /auth/register/with-phone-verification - Register with Phone Verification"
PHONE_VERIFY="+1555$(shuf -i 1000000-9999999 -n 1)"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register/with-phone-verification" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"phone\": \"${PHONE_VERIFY}\",
    \"password\": \"${PASSWORD}\",
    \"password_confirmation\": \"${PASSWORD}\",
    \"first_name\": \"TestPhone\",
    \"last_name\": \"Verify\",
    \"date_of_birth\": \"1995-05-15\"
  }")

print_response "$RESPONSE"

# ============================================================================
# LOGIN & LOGOUT ENDPOINTS (6)
# ============================================================================

print_test "2.1 POST /auth/login - Login with Email"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"login\": \"${RANDOM_EMAIL}\",
    \"password\": \"${PASSWORD}\",
    \"remember\": true
  }")

if echo "$RESPONSE" | jq -e '.token' > /dev/null 2>&1; then
    TOKEN=$(echo "$RESPONSE" | jq -r '.token')
    print_success "Login successful - Token obtained"
    print_response "$RESPONSE"
else
    print_error "Login failed"
    print_response "$RESPONSE"
fi

print_test "2.2 GET /auth/sessions - List Active Sessions"
RESPONSE=$(curl -s -X GET "${BASE_URL}/auth/sessions" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")

if echo "$RESPONSE" | jq -e '.sessions' > /dev/null 2>&1; then
    print_success "Sessions retrieved"
    SESSION_ID=$(echo "$RESPONSE" | jq -r '.sessions[0].id // empty')
    DEVICE_ID=$(echo "$RESPONSE" | jq -r '.sessions[0].device_id // empty')
    print_response "$RESPONSE"
else
    print_error "Failed to retrieve sessions"
    print_response "$RESPONSE"
fi

print_test "2.3 POST /auth/logout/device/{device_id} - Logout Specific Device"
if [ -n "$DEVICE_ID" ]; then
    RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/logout/device/${DEVICE_ID}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Accept: application/json")
    print_response "$RESPONSE"
else
    print_error "No device_id available to test"
fi

print_test "2.4 DELETE /auth/sessions/{session_id} - Delete Session"
if [ -n "$SESSION_ID" ]; then
    RESPONSE=$(curl -s -X DELETE "${BASE_URL}/auth/sessions/${SESSION_ID}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Accept: application/json")
    print_response "$RESPONSE"
else
    print_error "No session_id available to test"
fi

# Login again for remaining tests
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"login\": \"${RANDOM_EMAIL}\", \"password\": \"${PASSWORD}\"}")
TOKEN=$(echo "$RESPONSE" | jq -r '.token // empty')

print_test "2.5 POST /auth/logout/all-devices - Logout All Devices"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/logout/all-devices" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

# Login again for remaining tests
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"login\": \"${RANDOM_EMAIL}\", \"password\": \"${PASSWORD}\"}")
TOKEN=$(echo "$RESPONSE" | jq -r '.token // empty')

print_test "2.6 POST /auth/logout - Logout Current Session"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/logout" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")

if echo "$RESPONSE" | jq -e '.message' > /dev/null 2>&1; then
    print_success "Logout successful"
    print_response "$RESPONSE"
else
    print_error "Logout failed"
    print_response "$RESPONSE"
fi

# Login again for verification tests
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"login\": \"${RANDOM_EMAIL}\", \"password\": \"${PASSWORD}\"}")
TOKEN=$(echo "$RESPONSE" | jq -r '.token // empty')

# ============================================================================
# EMAIL VERIFICATION ENDPOINTS (4)
# ============================================================================

print_test "3.1 POST /auth/verification/email/send - Send Email Verification Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/email/send" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

print_test "3.2 GET /auth/verification/email/status - Check Email Status"
RESPONSE=$(curl -s -X GET "${BASE_URL}/auth/verification/email/status" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

print_test "3.3 POST /auth/verification/email/resend - Resend Email Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/email/resend" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

print_test "3.4 POST /auth/verification/email/verify - Verify Email Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/email/verify" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"code\": \"123456\"}")
print_response "$RESPONSE"

# ============================================================================
# PHONE VERIFICATION ENDPOINTS (3)
# ============================================================================

print_test "4.1 POST /auth/verification/phone/send - Send Phone Verification Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/phone/send" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

print_test "4.2 POST /auth/verification/phone/resend - Resend Phone Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/phone/resend" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/json")
print_response "$RESPONSE"

print_test "4.3 POST /auth/verification/phone/verify - Verify Phone Code"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/verification/phone/verify" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"code\": \"123456\"}")
print_response "$RESPONSE"

# ============================================================================
# PASSWORD MANAGEMENT ENDPOINTS (3)
# ============================================================================

print_test "5.1 POST /auth/password/forgot - Request Password Reset"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/password/forgot" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"identifier\": \"${RANDOM_EMAIL}\"}")
print_response "$RESPONSE"

print_test "5.2 POST /auth/password/reset - Reset Password with Token"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/password/reset" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"identifier\": \"${RANDOM_EMAIL}\",
    \"code\": \"123456\",
    \"password\": \"NewPassword123!\",
    \"password_confirmation\": \"NewPassword123!\"
  }")
print_response "$RESPONSE"

print_test "5.3 POST /auth/password/change - Change Password (Authenticated)"
RESPONSE=$(curl -s -X PUT "${BASE_URL}/auth/password/change" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"current_password\": \"${PASSWORD}\",
    \"new_password\": \"UpdatedPassword123!\",
    \"new_password_confirmation\": \"UpdatedPassword123!\"
  }")
print_response "$RESPONSE"

# ============================================================================
# SOCIAL AUTHENTICATION ENDPOINTS (2)
# ============================================================================

print_test "6.1 POST /auth/social/google - Google OAuth Login"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/social/google" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"token\": \"fake_google_token_for_testing\"}")
print_response "$RESPONSE"

print_test "6.2 POST /auth/social/apple - Apple OAuth Login"
RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/social/apple" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"token\": \"fake_apple_token_for_testing\"}")
print_response "$RESPONSE"

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    TESTING COMPLETE                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo -e "\n${GREEN}All 21 endpoints have been tested.${NC}"
echo -e "${YELLOW}Review the output above for detailed results.${NC}\n"
