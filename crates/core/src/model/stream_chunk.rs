use serde::{Deserialize, Serialize};

/// A single chunk from a streaming LLM response.
/// Used for incremental rendering on the UI side.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct StreamChunk {
    /// The incremental text delta for this chunk.
    pub content: String,
    /// The index of the choice this chunk belongs to (usually 0).
    pub index: u32,
    /// Set when the stream has completed.
    pub finish_reason: Option<String>,
}

/// Represents the state of a streaming LLM response.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum StreamState {
    /// Initial state, before any chunks arrive.
    Pending,
    /// Chunks are arriving.
    Streaming,
    /// The stream completed normally.
    Done,
    /// The stream ended with an error.
    Error(String),
}
