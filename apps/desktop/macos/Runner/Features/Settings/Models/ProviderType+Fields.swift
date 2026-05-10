import Foundation

extension ProviderType {
  var configFields: [ProviderConfigField] {
    switch self {
    case .baidu:
      return [
        ProviderConfigField(
          key: "appId", label: "App ID", placeholder: "", isSecret: false, isOptional: false),
        ProviderConfigField(
          key: "appKey", label: "App Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://fanyi-api.baidu.com",
          isSecret: false, isOptional: true),
      ]
    case .caiyun:
      return [
        ProviderConfigField(
          key: "token", label: "Token", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "requestId", label: "Request ID", placeholder: "", isSecret: false,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "http://api.interpreter.caiyunai.com",
          isSecret: false, isOptional: true),
      ]
    case .deepL:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://api.deepl.com",
          isSecret: false, isOptional: true),
      ]
    case .google:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "AIza…", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://translation.googleapis.com",
          isSecret: false, isOptional: true),
      ]
    case .iciba:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "", isSecret: false, isOptional: true),
      ]
    case .tencent:
      return [
        ProviderConfigField(
          key: "secretId", label: "Secret ID", placeholder: "", isSecret: false,
          isOptional: false),
        ProviderConfigField(
          key: "secretKey", label: "Secret Key", placeholder: "", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "", isSecret: false, isOptional: true),
      ]
    case .youdao:
      return [
        ProviderConfigField(
          key: "appKey", label: "App Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "appSecret", label: "App Secret", placeholder: "", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://openapi.youdao.com",
          isSecret: false, isOptional: true),
        ProviderConfigField(
          key: "pictureBaseUrl", label: "Picture Base URL",
          placeholder: "https://picdict.youdao.com", isSecret: false, isOptional: true),
      ]
    }
  }
}
