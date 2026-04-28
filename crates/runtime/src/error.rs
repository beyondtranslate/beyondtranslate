use thiserror::Error;

#[derive(Debug, Error)]
pub enum RuntimeError {
    #[error("failed to read config file `{path}`: {source}")]
    ReadConfigFile {
        path: String,
        #[source]
        source: std::io::Error,
    },
    #[error("failed to parse config yaml: {0}")]
    ParseConfig(#[from] serde_yaml::Error),
    #[error("provider `{0}` is not supported")]
    UnknownProvider(String),
    #[error("provider `{0}` is not enabled in this build")]
    ProviderNotEnabled(String),
    #[error("provider `{provider}` config is invalid: {source}")]
    InvalidProviderConfig {
        provider: String,
        #[source]
        source: serde_yaml::Error,
    },
}
