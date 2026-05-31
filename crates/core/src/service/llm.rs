use async_trait::async_trait;
use thiserror::Error;

use crate::model::{ChatRequest, ChatResponse, StreamChunk};

// ── Error ─────────────────────────────────────────────────────────────────────

#[derive(Debug, Error, Clone)]
pub enum LlmError {
    #[error("configuration error: {0}")]
    ConfigError(String),
    #[error("authentication failed: {0}")]
    AuthError(String),
    #[error("rate limited: {0}")]
    RateLimitError(String),
    #[error("invalid request: {0}")]
    InvalidRequest(String),
    #[error("network error: {0}")]
    NetworkError(String),
    #[error("serialization error: {0}")]
    SerializationError(String),
    #[error("stream error: {0}")]
    StreamError(String),
    #[error("unsupported operation: {0}")]
    UnsupportedOperation(String),
}

// ── Stream Receiver ───────────────────────────────────────────────────────────

/// A receive end of an unbounded mpsc channel for streaming LLM chunks.
///
/// This is a thin wrapper around a crossbeam-style channel receiver
/// that yields [`StreamChunk`] values.
pub struct LlmStreamReceiver {
    pub rx: std::sync::mpsc::Receiver<StreamChunk>,
}

impl LlmStreamReceiver {
    /// Block until the next chunk arrives.
    /// Returns `None` when the stream is closed (sender dropped).
    pub fn recv(&self) -> Result<StreamChunk, LlmError> {
        self.rx
            .recv()
            .map_err(|e| LlmError::StreamError(e.to_string()))
    }

    /// Try to receive a chunk without blocking.
    pub fn try_recv(&self) -> Option<StreamChunk> {
        self.rx.try_recv().ok()
    }
}

// ── Service Trait ─────────────────────────────────────────────────────────────

/// A service that communicates with a Large Language Model (LLM) API.
///
/// Implementations handle the specifics of each provider's API (OpenAI,
/// Anthropic, Ollama, etc.) while exposing a unified interface.
#[async_trait]
pub trait LlmService: Send + Sync {
    /// Returns the display name of this LLM provider (e.g. "openai", "anthropic").
    fn provider_name(&self) -> &'static str;

    /// Returns the list of available model identifiers (from config, sync).
    fn available_models(&self) -> Vec<String>;

    /// Fetches the list of available models from the provider's API.
    async fn list_models(&self) -> Result<Vec<String>, LlmError>;

    /// Send a chat completion request and receive the full response.
    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError>;

    /// Send a streaming chat completion request.
    ///
    /// Returns a receiver that yields [`StreamChunk`] values as they arrive.
    /// The stream will be closed when the response is complete or on error.
    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError>;
}
