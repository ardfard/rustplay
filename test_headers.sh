#!/bin/bash

# Test script for header extraction examples

BASE_URL="http://localhost:3000"

echo "=== Testing Header Extraction Examples ==="
echo

# Test 1: Login to get a token
echo "1. Testing login endpoint..."
curl -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "test@mail.com", "password": "test"}' \
  -w "\nStatus: %{http_code}\n\n"

# Test 2: Protected endpoint with Bearer token (using TypedHeader)
echo "2. Testing protected endpoint with Bearer token..."
curl -X GET "$BASE_URL/protected/auth" \
  -H "Authorization: Bearer fake-jwt-token-12345" \
  -w "\nStatus: %{http_code}\n\n"

# Test 3: Protected endpoint with API key (manual validation)
echo "3. Testing protected endpoint with API key..."
curl -X GET "$BASE_URL/protected/api-key" \
  -H "X-API-Key: my-super-secret-api-key-12345" \
  -w "\nStatus: %{http_code}\n\n"

# Test 4: Manual header extraction
echo "4. Testing manual header extraction..."
curl -X GET "$BASE_URL/protected/manual" \
  -H "X-API-Key: manual-test-key" \
  -H "User-Agent: ManualTestClient/2.0" \
  -w "\nStatus: %{http_code}\n\n"

# Test 5: Error cases
echo "5. Testing error cases..."

echo "5a. Missing API key:"
curl -X GET "$BASE_URL/protected/api-key" \
  -w "\nStatus: %{http_code}\n\n"

echo "5b. Invalid API key (too short):"
curl -X GET "$BASE_URL/protected/api-key" \
  -H "X-API-Key: short" \
  -w "\nStatus: %{http_code}\n\n"

echo "5c. Invalid Bearer token:"
curl -X GET "$BASE_URL/protected/auth" \
  -H "Authorization: Bearer invalid-token" \
  -w "\nStatus: %{http_code}\n\n"

echo "5d. Missing Authorization header:"
curl -X GET "$BASE_URL/protected/auth" \
  -w "\nStatus: %{http_code}\n\n"

echo "=== All tests completed ==="
