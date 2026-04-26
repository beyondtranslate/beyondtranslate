use std::sync::Arc;

use crate::{LookUpRequest, LookUpResponse};

use super::{
    DictionaryError, DictionaryProvider, DictionaryServiceError, DictionaryServiceResult,
};

pub struct DictionaryService {
    primary: Arc<dyn DictionaryProvider>,
    fallbacks: Vec<Arc<dyn DictionaryProvider>>,
}

impl DictionaryService {
    pub fn new(
        primary: Arc<dyn DictionaryProvider>,
        fallbacks: Vec<Arc<dyn DictionaryProvider>>,
    ) -> Self {
        Self { primary, fallbacks }
    }

    pub async fn look_up(
        &self,
        request: LookUpRequest,
    ) -> DictionaryServiceResult<LookUpResponse> {
        let mut last_error = None;

        for provider in std::iter::once(&self.primary).chain(self.fallbacks.iter()) {
            match provider.look_up(request.clone()).await {
                Ok(result) => return Ok(result),
                Err(error) => last_error = Some(error),
            }
        }

        Err(map_last_error(last_error))
    }
}

fn map_last_error(last_error: Option<DictionaryError>) -> DictionaryServiceError {
    last_error
        .map(DictionaryServiceError::from)
        .unwrap_or(DictionaryServiceError::NoProvidersConfigured)
}
