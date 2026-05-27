use serde::{Deserialize, Serialize};

use super::ChatMessage;

/// Request to an LLM chat/completion API.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ChatRequest {
    /// The model identifier (e.g. "gpt-4o", "claude-sonnet-4-20250514").
    pub model: String,
    /// The conversation messages.
    pub messages: Vec<ChatMessage>,
    /// Sampling temperature (0.0–2.0). Lower values are more deterministic.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub temperature: Option<f32>,
    /// Maximum tokens to generate.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub max_tokens: Option<u32>,
    /// Whether to return a streaming response.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stream: Option<bool>,
}
