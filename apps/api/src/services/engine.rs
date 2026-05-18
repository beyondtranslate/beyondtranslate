use beyondtranslate_engine::{from_yaml_str, Engine};
use worker::Env;

use crate::{config::ApiConfig, error::ApiError};

pub fn load_engine(env: &Env) -> Result<Engine, ApiError> {
    let rendered = ApiConfig::default().render_runtime_config(env);
    from_yaml_str(&rendered).map_err(ApiError::from_engine_error)
}
