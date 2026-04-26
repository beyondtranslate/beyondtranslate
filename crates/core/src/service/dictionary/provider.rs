use async_trait::async_trait;

use crate::{LookUpRequest, LookUpResponse};

use super::error::DictionaryResult;

#[async_trait]
pub trait DictionaryProvider: Send + Sync {
    async fn look_up(&self, request: LookUpRequest) -> DictionaryResult<LookUpResponse>;
}
