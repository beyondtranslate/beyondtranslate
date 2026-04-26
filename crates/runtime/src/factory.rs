use std::sync::Arc;

use beyondtranslate_core::{
    DictionaryError, DictionaryProvider, DictionaryService, TranslationError, TranslationProvider,
    TranslationService,
};
#[cfg(feature = "baidu")]
use beyondtranslate_providers::BaiduProvider;
#[cfg(feature = "caiyun")]
use beyondtranslate_providers::CaiyunProvider;
#[cfg(feature = "deepl")]
use beyondtranslate_providers::DeepLProvider;
#[cfg(feature = "google")]
use beyondtranslate_providers::GoogleProvider;
#[cfg(feature = "iciba")]
use beyondtranslate_providers::IcibaProvider;
#[cfg(feature = "tencent")]
use beyondtranslate_providers::TencentProvider;
#[cfg(feature = "youdao")]
use beyondtranslate_providers::YoudaoProvider;

use crate::{
    DictionaryProviderConfig, DictionaryRuntimeResult, RuntimeResult, TranslationProviderConfig,
};

pub fn create_translator(config: TranslationProviderConfig) -> RuntimeResult<TranslationService> {
    let (primary, fallbacks) = build_translation_provider_chain(config)?;
    Ok(TranslationService::new(primary, fallbacks))
}

pub fn create_dictionary(config: DictionaryProviderConfig) -> DictionaryRuntimeResult<DictionaryService> {
    let (primary, fallbacks) = build_dictionary_provider_chain(config)?;
    Ok(DictionaryService::new(primary, fallbacks))
}

fn build_translation_provider_chain(
    config: TranslationProviderConfig,
) -> RuntimeResult<(Arc<dyn TranslationProvider>, Vec<Arc<dyn TranslationProvider>>)> {
    let mut providers = Vec::new();
    flatten_translation_provider_config(config, &mut providers)?;

    let mut providers = providers.into_iter();
    let primary = providers.next().ok_or_else(|| {
        TranslationError::ConfigError("at least one translation provider must be configured".to_owned())
    })?;

    Ok((primary, providers.collect()))
}

fn build_dictionary_provider_chain(
    config: DictionaryProviderConfig,
) -> DictionaryRuntimeResult<(Arc<dyn DictionaryProvider>, Vec<Arc<dyn DictionaryProvider>>)> {
    let mut providers = Vec::new();
    flatten_dictionary_provider_config(config, &mut providers)?;

    let mut providers = providers.into_iter();
    let primary = providers.next().ok_or_else(|| {
        DictionaryError::ConfigError("at least one dictionary provider must be configured".to_owned())
    })?;

    Ok((primary, providers.collect()))
}

fn flatten_translation_provider_config(
    config: TranslationProviderConfig,
    providers: &mut Vec<Arc<dyn TranslationProvider>>,
) -> RuntimeResult<()> {
    match config {
        TranslationProviderConfig::Chain { primary, fallbacks } => {
            flatten_translation_provider_config(*primary, providers)?;
            for fallback in fallbacks {
                flatten_translation_provider_config(fallback, providers)?;
            }
            Ok(())
        }
        #[cfg(feature = "baidu")]
        TranslationProviderConfig::Baidu {
            app_id,
            app_key,
            base_url,
        } => {
            let provider = BaiduProvider::builder()
                .app_id(app_id)
                .app_key(app_key)
                .base_url(base_url.unwrap_or_else(|| "https://fanyi-api.baidu.com".to_owned()))
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "baidu"))]
        TranslationProviderConfig::Baidu { .. } => Err(TranslationError::ConfigError(
            "Baidu support requires the `baidu` feature".to_owned(),
        )),
        #[cfg(feature = "caiyun")]
        TranslationProviderConfig::Caiyun {
            token,
            request_id,
            base_url,
        } => {
            let provider = CaiyunProvider::builder()
                .token(token)
                .request_id(request_id)
                .base_url(
                    base_url.unwrap_or_else(|| "http://api.interpreter.caiyunai.com".to_owned()),
                )
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "caiyun"))]
        TranslationProviderConfig::Caiyun { .. } => Err(TranslationError::ConfigError(
            "Caiyun support requires the `caiyun` feature".to_owned(),
        )),
        #[cfg(feature = "deepl")]
        TranslationProviderConfig::DeepL { api_key, base_url } => {
            let provider = DeepLProvider::builder()
                .api_key(api_key)
                .base_url(base_url.unwrap_or_else(|| "https://api.deepl.com".to_owned()))
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "deepl"))]
        TranslationProviderConfig::DeepL { .. } => Err(TranslationError::ConfigError(
            "DeepL support requires the `deepl` feature".to_owned(),
        )),
        #[cfg(feature = "google")]
        TranslationProviderConfig::Google { api_key, base_url } => {
            let provider = GoogleProvider::builder()
                .api_key(api_key)
                .base_url(
                    base_url.unwrap_or_else(|| "https://translation.googleapis.com".to_owned()),
                )
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "google"))]
        TranslationProviderConfig::Google { .. } => Err(TranslationError::ConfigError(
            "Google support requires the `google` feature".to_owned(),
        )),
        #[cfg(feature = "iciba")]
        TranslationProviderConfig::Iciba { api_key, base_url } => {
            let provider = IcibaProvider::builder()
                .api_key(api_key)
                .base_url(base_url.unwrap_or_else(|| "http://dict-co.iciba.com".to_owned()))
                .build()
                .map_err(dictionary_error_to_translation_error)?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "iciba"))]
        TranslationProviderConfig::Iciba { .. } => Err(TranslationError::ConfigError(
            "Iciba support requires the `iciba` feature".to_owned(),
        )),
        #[cfg(feature = "tencent")]
        TranslationProviderConfig::Tencent {
            secret_id,
            secret_key,
            base_url,
        } => {
            let provider = TencentProvider::builder()
                .secret_id(secret_id)
                .secret_key(secret_key)
                .base_url(base_url.unwrap_or_else(|| "https://tmt.tencentcloudapi.com".to_owned()))
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "tencent"))]
        TranslationProviderConfig::Tencent { .. } => Err(TranslationError::ConfigError(
            "Tencent support requires the `tencent` feature".to_owned(),
        )),
        #[cfg(feature = "youdao")]
        TranslationProviderConfig::Youdao {
            app_key,
            app_secret,
            base_url,
            picture_base_url,
        } => {
            let provider = YoudaoProvider::builder()
                .app_key(app_key)
                .app_secret(app_secret)
                .base_url(base_url.unwrap_or_else(|| "https://openapi.youdao.com".to_owned()))
                .picture_base_url(
                    picture_base_url.unwrap_or_else(|| "https://picdict.youdao.com".to_owned()),
                )
                .build()
                .map_err(dictionary_error_to_translation_error)?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "youdao"))]
        TranslationProviderConfig::Youdao { .. } => Err(TranslationError::ConfigError(
            "Youdao support requires the `youdao` feature".to_owned(),
        )),
    }
}

fn flatten_dictionary_provider_config(
    config: DictionaryProviderConfig,
    providers: &mut Vec<Arc<dyn DictionaryProvider>>,
) -> DictionaryRuntimeResult<()> {
    match config {
        DictionaryProviderConfig::Chain { primary, fallbacks } => {
            flatten_dictionary_provider_config(*primary, providers)?;
            for fallback in fallbacks {
                flatten_dictionary_provider_config(fallback, providers)?;
            }
            Ok(())
        }
        #[cfg(feature = "iciba")]
        DictionaryProviderConfig::Iciba { api_key, base_url } => {
            let provider = IcibaProvider::builder()
                .api_key(api_key)
                .base_url(base_url.unwrap_or_else(|| "http://dict-co.iciba.com".to_owned()))
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "iciba"))]
        DictionaryProviderConfig::Iciba { .. } => Err(DictionaryError::ConfigError(
            "Iciba support requires the `iciba` feature".to_owned(),
        )),
        #[cfg(feature = "youdao")]
        DictionaryProviderConfig::Youdao {
            app_key,
            app_secret,
            base_url,
            picture_base_url,
        } => {
            let provider = YoudaoProvider::builder()
                .app_key(app_key)
                .app_secret(app_secret)
                .base_url(base_url.unwrap_or_else(|| "https://openapi.youdao.com".to_owned()))
                .picture_base_url(
                    picture_base_url.unwrap_or_else(|| "https://picdict.youdao.com".to_owned()),
                )
                .build()?;
            providers.push(Arc::new(provider));
            Ok(())
        }
        #[cfg(not(feature = "youdao"))]
        DictionaryProviderConfig::Youdao { .. } => Err(DictionaryError::ConfigError(
            "Youdao support requires the `youdao` feature".to_owned(),
        )),
    }
}

fn dictionary_error_to_translation_error(error: DictionaryError) -> TranslationError {
    match error {
        DictionaryError::UnsupportedMethod(method) => TranslationError::UnsupportedMethod(method),
        DictionaryError::ConfigError(message) => TranslationError::ConfigError(message),
        DictionaryError::AuthError(message) => TranslationError::AuthError(message),
        DictionaryError::RateLimitError(message) => TranslationError::RateLimitError(message),
        DictionaryError::InvalidRequest(message) => TranslationError::InvalidRequest(message),
        DictionaryError::ProviderError { provider, message } => {
            TranslationError::ProviderError { provider, message }
        }
        DictionaryError::NetworkError(message) => TranslationError::NetworkError(message),
        DictionaryError::SerializationError(message) => {
            TranslationError::SerializationError(message)
        }
    }
}
