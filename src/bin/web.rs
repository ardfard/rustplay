use std::{sync::{Arc, atomic::AtomicUsize}, borrow::Borrow};

use axum::{Router, routing::{get, post}, Json, response::IntoResponse, extract::State};
use hyper::StatusCode;
use serde::{Deserialize, Serialize};
use tokio::sync::Mutex;



#[derive(Deserialize, Serialize)]
struct User {
    email: String,
    password: String,
}

#[derive(Serialize)]
struct LoginResponse {
    message: String,
}


async fn login(State(app): State<Arc<AppState>>, Json(payload): Json<User>) -> impl IntoResponse {
    {
        let mut c = app.counter.lock().await;
        *c += 1;
    }
    if payload.email == "test@mail.com" && payload.password == "test" {
        return (StatusCode::OK, Json(LoginResponse {
            message: "Login success".to_string(),
        }))
    } else {
        return (StatusCode::OK, Json(LoginResponse {
            message: "Login failed".to_string(),
        }))
    }
}

async fn show_counter(State(app): State<Arc<AppState>>) -> impl IntoResponse {
    let c = app.counter.lock().await;
    (StatusCode::OK, Json(*c))
}

struct AppState {
    counter: Mutex<u64>,
}


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {

    let state = Arc::new(AppState {
        counter: Mutex::new(0),
    });

    let app = Router::new()
        .route("/login", post(login))
        .route("/counter", get(show_counter))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;
    
    return  Ok(());
}