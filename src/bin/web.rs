use std::{sync::Arc, time::Duration, collections::HashMap, path::PathBuf};

use axum::{
    Router, 
    routing::{get, post, delete}, 
    Json, 
    response::IntoResponse, 
    extract::{State, Request, Extension, Query},
    http::{StatusCode, header::USER_AGENT, HeaderMap},
    middleware::{self, Next},
    response::Response,
    body::Bytes,
};
use serde::{Deserialize, Serialize};
use tokio::{
    sync::Mutex,
    fs::File,
    io::AsyncWriteExt,
};
use tower::ServiceBuilder;
use tower_http::{cors::{Any, CorsLayer}, timeout, trace::TraceLayer};
use uuid::Uuid;

#[derive(Deserialize, Serialize)]
struct User {
    email: String,
    password: String,
}

#[derive(Serialize)]
struct LoginResponse {
    message: String,
    token: Option<String>,
}

// Data structures to hold extracted and validated header values
#[derive(Debug, Clone, Serialize)]
pub struct AuthenticatedUser {
    pub user_id: String,
    pub token: String,
}

#[derive(Debug, Clone, Serialize)]
pub struct ApiKeyInfo {
    pub key: String,
    pub permissions: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct RequestContext {
    pub user_agent: Option<String>,
    pub api_key: Option<ApiKeyInfo>,
    pub authenticated_user: Option<AuthenticatedUser>,
}

// Middleware to extract and validate headers
async fn extract_headers(mut request: Request, next: Next) -> Result<Response, StatusCode> {
    let headers = request.headers();
    let mut context = RequestContext {
        user_agent: None,
        api_key: None,
        authenticated_user: None,
    };

    // Extract User-Agent
    if let Some(user_agent) = headers.get(USER_AGENT) {
        if let Ok(ua_str) = user_agent.to_str() {
            context.user_agent = Some(ua_str.to_string());
        }
    }

    // Extract and validate API Key
    if let Some(api_key) = headers.get("X-API-Key") {
        if let Ok(key_str) = api_key.to_str() {
            if key_str.len() >= 10 {
                // In a real app, you'd validate against a database
                let permissions = match key_str {
                    key if key.starts_with("admin-") => vec!["read".to_string(), "write".to_string(), "admin".to_string()],
                    key if key.starts_with("user-") => vec!["read".to_string()],
                    _ => vec!["read".to_string()],
                };
                
                context.api_key = Some(ApiKeyInfo {
                    key: key_str.to_string(),
                    permissions,
                });
            }
        }
    }

    // Extract and validate Authorization Bearer token
    if let Some(auth_header) = headers.get("Authorization") {
        if let Ok(auth_str) = auth_header.to_str() {
            if auth_str.starts_with("Bearer ") {
                let token = &auth_str[7..];
                if !token.is_empty() {
                    // In a real app, you'd validate the JWT token
                    if token == "fake-jwt-token-12345" {
                        context.authenticated_user = Some(AuthenticatedUser {
                            user_id: "user-123".to_string(),
                            token: token.to_string(),
                        });
                    }
                }
            }
        }
    }

    // Insert the context into request extensions
    request.extensions_mut().insert(context);

    // Continue to the next middleware/handler
    Ok(next.run(request).await)
}

// Middleware specifically for API key authentication
async fn require_api_key(request: Request, next: Next) -> Result<Response, StatusCode> {
    let headers = request.headers();
    
    if let Some(api_key) = headers.get("X-API-Key") {
        if let Ok(key_str) = api_key.to_str() {
            if key_str.len() >= 10 {
                // API key is valid, continue
                return Ok(next.run(request).await);
            }
        }
    }
    
    // API key is missing or invalid
    Err(StatusCode::UNAUTHORIZED)
}

// Middleware specifically for Bearer token authentication
async fn require_auth(request: Request, next: Next) -> Result<Response, StatusCode> {
    let headers = request.headers();
    
    if let Some(auth_header) = headers.get("Authorization") {
        if let Ok(auth_str) = auth_header.to_str() {
            if auth_str.starts_with("Bearer ") {
                let token = &auth_str[7..];
                if !token.is_empty() && token == "fake-jwt-token-12345" {
                    // Token is valid, continue
                    return Ok(next.run(request).await);
                }
            }
        }
    }
    
    // Token is missing or invalid
    Err(StatusCode::UNAUTHORIZED)
}

async fn login(State(app): State<Arc<AppState>>, Json(payload): Json<User>) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    if payload.email == "test@mail.com" && payload.password == "test" {
        return (StatusCode::OK, Json(LoginResponse {
            message: "Login success".to_string(),
            token: Some("fake-jwt-token-12345".to_string()),
        }))
    } else {
        return (StatusCode::OK, Json(LoginResponse {
            message: "Login failed".to_string(),
            token: None,
        }))
    }
}

// Handler that uses extracted authenticated user data
async fn protected_with_auth(
    State(app): State<Arc<AppState>>,
    Extension(context): Extension<RequestContext>,
) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    
    // The middleware has already validated the token, so we can trust the context
    if let Some(user) = &context.authenticated_user {
        (StatusCode::OK, Json(serde_json::json!({
            "message": "Access granted with Bearer token",
            "user_id": user.user_id,
            "token": user.token,
            "user_agent": context.user_agent,
            "counter": *app.counter.lock().await
        })))
    } else {
        // This shouldn't happen if middleware is working correctly
        (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({
            "error": "Authentication context missing"
        })))
    }
}

// Handler that uses extracted API key data
async fn protected_with_api_key(
    State(app): State<Arc<AppState>>,
    Extension(context): Extension<RequestContext>,
) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    
    // The middleware has already validated the API key
    if let Some(api_key_info) = &context.api_key {
        (StatusCode::OK, Json(serde_json::json!({
            "message": "Access granted with API key",
            "api_key": api_key_info.key,
            "permissions": api_key_info.permissions,
            "user_agent": context.user_agent,
            "counter": *app.counter.lock().await
        })))
    } else {
        // This shouldn't happen if middleware is working correctly
        (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({
            "error": "API key context missing"
        })))
    }
}

// Handler that shows all extracted context data
async fn show_context(
    State(app): State<Arc<AppState>>,
    Extension(context): Extension<RequestContext>,
) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    
    (StatusCode::OK, Json(serde_json::json!({
        "message": "Request context extracted by middleware",
        "user_agent": context.user_agent,
        "api_key": context.api_key,
        "authenticated_user": context.authenticated_user,
        "counter": *app.counter.lock().await
    })))
}

// Handler that requires both API key and authentication
async fn admin_only(
    State(app): State<Arc<AppState>>,
    Extension(context): Extension<RequestContext>,
) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    
    // Check if user has admin permissions
    let has_admin_access = context.api_key
        .as_ref()
        .map(|api_key| api_key.permissions.contains(&"admin".to_string()))
        .unwrap_or(false);
    
    if has_admin_access {
        (StatusCode::OK, Json(serde_json::json!({
            "message": "Admin access granted",
            "user_id": context.authenticated_user.as_ref().map(|u| &u.user_id),
            "api_key": context.api_key.as_ref().map(|k| &k.key),
            "permissions": context.api_key.as_ref().map(|k| &k.permissions),
            "counter": *app.counter.lock().await
        })))
    } else {
        (StatusCode::FORBIDDEN, Json(serde_json::json!({
            "error": "Admin access required"
        })))
    }
}

async fn show_counter(State(app): State<Arc<AppState>>) -> impl IntoResponse {
    let c = app.counter.lock().await;
    (StatusCode::OK, Json(*c))
}

// 1. INITIATE UPLOAD - Create upload session
async fn initiate_upload(
    State(app): State<Arc<AppState>>,
    headers: HeaderMap,
) -> Result<Json<UploadResponse>, StatusCode> {
    let filename = headers
        .get("X-Filename")
        .and_then(|h| h.to_str().ok())
        .ok_or(StatusCode::BAD_REQUEST)?;
    
    let total_size: u64 = headers
        .get("X-File-Size")
        .and_then(|h| h.to_str().ok())
        .and_then(|s| s.parse().ok())
        .ok_or(StatusCode::BAD_REQUEST)?;

    let chunk_size: usize = headers
        .get("X-Chunk-Size")
        .and_then(|h| h.to_str().ok())
        .and_then(|s| s.parse().ok())
        .unwrap_or(1024 * 1024); // Default 1MB chunks

    // Validate file size (e.g., max 10GB)
    if total_size > 10 * 1024 * 1024 * 1024 {
        return Err(StatusCode::PAYLOAD_TOO_LARGE);
    }

    let session_id = Uuid::new_v4().to_string();
    let temp_path = app.upload_dir.join(format!("{}.tmp", session_id));
    let final_path = app.upload_dir.join(filename);

    let session = UploadSession {
        id: session_id.clone(),
        filename: filename.to_string(),
        total_size,
        uploaded_size: 0,
        chunk_size,
        temp_path: temp_path.clone(),
        final_path,
        checksum: None,
        created_at: std::time::SystemTime::now(),
        status: "uploading".to_string(),
    };

    // Store session
    {
        let mut sessions = app.upload_sessions.lock().await;
        sessions.insert(session_id.clone(), session);
    }

    // Create temp file
    File::create(&temp_path).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    Ok(Json(UploadResponse {
        message: "Upload session created".to_string(),
        session_id,
        filename: filename.to_string(),
        total_size,
        chunk_size,
    }))
}

// 2. UPLOAD CHUNK - Stream individual chunks
async fn upload_chunk(
    State(app): State<Arc<AppState>>,
    headers: HeaderMap,
    body: Bytes,
) -> Result<Json<ChunkResponse>, StatusCode> {
    let session_id = headers
        .get("X-Session-ID")
        .and_then(|h| h.to_str().ok())
        .ok_or(StatusCode::BAD_REQUEST)?;

    let chunk_number: usize = headers
        .get("X-Chunk-Number")
        .and_then(|h| h.to_str().ok())
        .and_then(|s| s.parse().ok())
        .ok_or(StatusCode::BAD_REQUEST)?;

    // Get session
    let mut session = {
        let mut sessions = app.upload_sessions.lock().await;
        sessions.get_mut(session_id)
            .ok_or(StatusCode::NOT_FOUND)?
            .clone()
    };

    // Validate chunk
    let expected_offset = (chunk_number - 1) * session.chunk_size;
    if session.uploaded_size != expected_offset as u64 {
        return Err(StatusCode::BAD_REQUEST);
    }

    // Write chunk to temp file
    let mut file = tokio::fs::OpenOptions::new()
        .write(true)
        .append(true)
        .open(&session.temp_path)
        .await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    file.write_all(&body).await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    file.flush().await
        .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    // Update session
    session.uploaded_size += body.len() as u64;
    let completed = session.uploaded_size >= session.total_size;
    let percentage = (session.uploaded_size as f64 / session.total_size as f64) * 100.0;

    if completed {
        // Move temp file to final location
        tokio::fs::rename(&session.temp_path, &session.final_path).await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        
        session.status = "completed".to_string();
    }

    // Update session in storage
    {
        let mut sessions = app.upload_sessions.lock().await;
        sessions.insert(session_id.to_string(), session.clone());
    }

    Ok(Json(ChunkResponse {
        message: if completed { "Upload completed".to_string() } else { "Chunk uploaded".to_string() },
        session_id: session_id.to_string(),
        uploaded_size: session.uploaded_size,
        total_size: session.total_size,
        percentage,
        completed,
    }))
}

// 3. CHECK UPLOAD PROGRESS
async fn check_progress(
    State(app): State<Arc<AppState>>,
    Query(params): Query<HashMap<String, String>>,
) -> Result<Json<UploadProgress>, StatusCode> {
    let session_id = params.get("session_id")
        .ok_or(StatusCode::BAD_REQUEST)?;

    let session = {
        let sessions = app.upload_sessions.lock().await;
        sessions.get(session_id)
            .ok_or(StatusCode::NOT_FOUND)?
            .clone()
    };

    let percentage = (session.uploaded_size as f64 / session.total_size as f64) * 100.0;
    let status = if session.uploaded_size >= session.total_size {
        "completed"
    } else {
        "uploading"
    };

    Ok(Json(UploadProgress {
        session_id: session.id,
        filename: session.filename,
        total_size: session.total_size,
        uploaded_size: session.uploaded_size,
        percentage,
        status: status.to_string(),
    }))
}

// 4. CANCEL UPLOAD
async fn cancel_upload(
    State(app): State<Arc<AppState>>,
    Query(params): Query<HashMap<String, String>>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    let session_id = params.get("session_id")
        .ok_or(StatusCode::BAD_REQUEST)?;

    let session = {
        let mut sessions = app.upload_sessions.lock().await;
        sessions.remove(session_id)
            .ok_or(StatusCode::NOT_FOUND)?
    };

    // Clean up temp file
    let _ = tokio::fs::remove_file(&session.temp_path).await;

    Ok(Json(serde_json::json!({
        "message": "Upload cancelled",
        "session_id": session_id
    })))
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UploadSession {
    pub id: String,
    pub filename: String,
    pub total_size: u64,
    pub uploaded_size: u64,
    pub chunk_size: usize,
    pub temp_path: PathBuf,
    pub final_path: PathBuf,
    pub checksum: Option<String>,
    pub created_at: std::time::SystemTime,
    pub status: String, // "uploading", "completed", "failed"
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UploadProgress {
    pub session_id: String,
    pub filename: String,
    pub total_size: u64,
    pub uploaded_size: u64,
    pub percentage: f64,
    pub status: String,
}

#[derive(Serialize)]
struct UploadResponse {
    message: String,
    session_id: String,
    filename: String,
    total_size: u64,
    chunk_size: usize,
}

#[derive(Serialize)]
struct ChunkResponse {
    message: String,
    session_id: String,
    uploaded_size: u64,
    total_size: u64,
    percentage: f64,
    completed: bool,
}

struct AppState {
    counter: Mutex<u64>,
    upload_sessions: Arc<Mutex<HashMap<String, UploadSession>>>,
    upload_dir: PathBuf,
}

impl AppState {
    pub fn new() -> Self {
        let upload_dir = std::env::current_dir().unwrap().join("uploads");
        std::fs::create_dir_all(&upload_dir).unwrap();
        
        Self {
            counter: Mutex::new(0),
            upload_sessions: Arc::new(Mutex::new(HashMap::new())),
            upload_dir,
        }
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    // Initialize tracing subscriber with debug level
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::DEBUG)
        .init();

    let state = Arc::new(AppState::new());

    let cors = CorsLayer::new()
        .allow_methods(Any)
        .allow_headers(Any);

    let timeout_layer = timeout::TimeoutLayer::new(Duration::from_secs(10));

    let trace = TraceLayer::new_for_http()
        .make_span_with(|request: &axum::http::Request<axum::body::Body>| {
            tracing::info_span!(
                "http_request",
                method = %request.method(),
                uri = %request.uri(),
                version = ?request.version(),
            )
        })
        .on_request(|_request: &axum::http::Request<axum::body::Body>, _span: &tracing::Span| {
            tracing::info!("started processing request");
        })
        .on_response(|_response: &axum::http::Response<axum::body::Body>, latency: std::time::Duration, _span: &tracing::Span| {
            tracing::info!("finished processing request latency={}ms", latency.as_millis());
        });

    let app = Router::new()
        // Public routes (no middleware)
        .route("/login", post(login))
        .route("/counter", get(show_counter));
        
    let context = Router::new()
        // Routes with header extraction middleware (but no authentication required)
        .route("/context", get(show_context))
        .route_layer(middleware::from_fn(extract_headers));
        
    let protected = Router::new()
        // Routes requiring API key authentication
        .route("/protected/api-key", get(protected_with_api_key))
        // .route_layer(middleware::from_fn(require_api_key))
        .route_layer(middleware::from_fn(extract_headers));
        
        // Routes requiring Bearer token authentication
        // .route("/protected/auth", get(protected_with_auth))
        // .route_layer(middleware::from_fn(require_auth))
        // .route_layer(middleware::from_fn(extract_headers));

    let admin = Router::new()    
        // Admin route requiring both API key and Bearer token
        .route("/admin", get(admin_only))
        .route_layer(middleware::from_fn(require_api_key))
        .route_layer(middleware::from_fn(require_auth))
        .route_layer(middleware::from_fn(extract_headers));


    let upload = Router::new()
        .route("/upload/initiate", post(initiate_upload))
        .route("/upload/chunk", post(upload_chunk))
        .route("/upload/progress", get(check_progress))
        .route("/upload/cancel", delete(cancel_upload))
        .route_layer(middleware::from_fn(require_auth))
        .route_layer(middleware::from_fn(extract_headers));

    let merge = app
        .merge(context)
        .merge(protected)
        .merge(admin)
        .merge(upload)
        .layer(
            ServiceBuilder::new()
            .layer(trace)
            .layer(cors)
            .layer(timeout_layer)
        )
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, merge).await?;
    
    return  Ok(());
}
