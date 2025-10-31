# Axum Header Extraction, Validation, and Usage Guide

This guide demonstrates different approaches to extract, validate, and make header values available to subsequent handlers in Axum.

## Overview

The example shows three main patterns for header handling:

1. **TypedHeader with headers crate** - For standard headers like Authorization
2. **Manual HeaderMap extraction** - For custom headers and validation logic
3. **Combined approach** - Using both patterns as needed

## Available Endpoints

### 1. Login Endpoint
- **Route**: `POST /login`
- **Purpose**: Authenticate and return a token
- **Body**: `{"email": "test@mail.com", "password": "test"}`
- **Response**: Returns a JWT token for testing

### 2. Bearer Token Authentication
- **Route**: `GET /protected/auth`
- **Headers**: `Authorization: Bearer fake-jwt-token-12345`
- **Pattern**: Uses `TypedHeader<Authorization<Bearer>>` from the headers crate
- **Validation**: Checks if token matches expected value

### 3. API Key Authentication
- **Route**: `GET /protected/api-key`
- **Headers**: `X-API-Key: my-super-secret-api-key-12345`
- **Pattern**: Manual extraction from `HeaderMap`
- **Validation**: Ensures API key is at least 10 characters long

### 4. Manual Header Extraction
- **Route**: `GET /protected/manual`
- **Headers**: Any headers (demonstrates flexible extraction)
- **Pattern**: Manual extraction showing multiple headers
- **Response**: Returns all extracted headers in JSON

## Code Patterns

### Pattern 1: TypedHeader (Recommended for Standard Headers)

```rust
use axum_extra::extract::TypedHeader;
use headers::{Authorization, authorization::Bearer};

async fn protected_with_auth(
    TypedHeader(auth): TypedHeader<Authorization<Bearer>>,
) -> impl IntoResponse {
    // auth.token() gives you the token string
    if auth.token() == "expected-token" {
        // Handle valid token
    } else {
        // Handle invalid token
    }
}
```

**Pros:**
- Type-safe
- Automatic parsing
- Works with standard headers
- Clean error handling

**Cons:**
- Limited to headers supported by the headers crate
- Less flexible for custom validation logic

### Pattern 2: Manual HeaderMap Extraction

```rust
use axum::http::header::HeaderMap;

async fn manual_extraction(headers: HeaderMap) -> impl IntoResponse {
    // Extract specific headers
    if let Some(api_key) = headers.get("X-API-Key") {
        if let Ok(key_str) = api_key.to_str() {
            // Validate the key
            if key_str.len() >= 10 {
                // Handle valid key
            }
        }
    }
    
    // Extract user agent
    if let Some(user_agent) = headers.get(USER_AGENT) {
        if let Ok(ua_str) = user_agent.to_str() {
            // Use user agent
        }
    }
}
```

**Pros:**
- Maximum flexibility
- Can handle any header
- Custom validation logic
- Access to all headers

**Cons:**
- More verbose
- Manual error handling
- No type safety for header values

### Pattern 3: Custom Extractor (Advanced)

For complex validation logic, you can create custom extractors by implementing `FromRequestParts`:

```rust
use axum::{
    async_trait,
    extract::FromRequestParts,
    http::{request::Parts, StatusCode},
};

struct ApiKey(String);

#[async_trait]
impl<S> FromRequestParts<S> for ApiKey
where
    S: Send + Sync,
{
    type Rejection = (StatusCode, &'static str);

    async fn from_request_parts(parts: &mut Parts, _state: &S) -> Result<Self, Self::Rejection> {
        let headers = &parts.headers;
        
        if let Some(api_key) = headers.get("X-API-Key") {
            if let Ok(key_str) = api_key.to_str() {
                if key_str.len() >= 10 {
                    return Ok(ApiKey(key_str.to_string()));
                }
            }
        }
        
        Err((StatusCode::UNAUTHORIZED, "Missing or invalid API key"))
    }
}
```

**Pros:**
- Reusable across handlers
- Encapsulates validation logic
- Type-safe usage in handlers
- Clean separation of concerns

**Cons:**
- More complex to implement
- Requires understanding of Axum internals

## Testing

Run the test script to see all patterns in action:

```bash
./test_headers.sh
```

This will test:
- Successful authentication with Bearer tokens
- API key validation
- Manual header extraction
- Error cases (missing/invalid headers)

## Dependencies

The following dependencies are required:

```toml
[dependencies]
axum = "0.8.4"
axum-extra = { version = "0.10.1", features = ["typed-header"] }
headers = "0.4.1"
serde_json = "1.0"
```

## Best Practices

1. **Use TypedHeader for standard headers** - It's type-safe and handles parsing automatically
2. **Use HeaderMap for custom headers** - When you need flexibility or custom validation
3. **Validate early** - Check headers at the handler level or in middleware
4. **Return appropriate HTTP status codes** - 401 for authentication failures, 400 for malformed requests
5. **Log security events** - Track authentication attempts and failures
6. **Use HTTPS in production** - Never send sensitive headers over unencrypted connections

## Security Considerations

- Always validate header values
- Sanitize input to prevent injection attacks
- Use secure token storage and transmission
- Implement rate limiting for authentication endpoints
- Log authentication attempts for monitoring
- Use strong, randomly generated API keys
- Implement proper token expiration and refresh mechanisms
