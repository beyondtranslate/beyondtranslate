import {
  Configuration,
  DictionariesApi,
  SystemApi,
  TranslationsApi,
  type DetectLanguageResponseEnvelope,
  type HealthResponseEnvelope,
  type LanguagePairListEnvelope,
  type LookUpResponseEnvelope,
  ResponseError,
  type TranslateResponseEnvelope,
} from '@beyondtranslate/client';

export class ApiClientService {
  private readonly systemApi: SystemApi;
  private readonly translationsApi: TranslationsApi;
  private readonly dictionariesApi: DictionariesApi;

  constructor(baseUrl: string) {
    const configuration = new Configuration({
      basePath: baseUrl.replace(/\/+$/, ''),
    });
    this.systemApi = new SystemApi(configuration);
    this.translationsApi = new TranslationsApi(configuration);
    this.dictionariesApi = new DictionariesApi(configuration);
  }

  async health(): Promise<HealthResponseEnvelope> {
    return this.systemApi.getHealth();
  }

  async translate(params: {
    provider: string;
    text: string;
    sourceLanguage?: string;
    targetLanguage?: string;
  }): Promise<TranslateResponseEnvelope> {
    return this.translationsApi.translateText({
      provider: params.provider as 'iciba',
      translateRequest: {
        sourceLanguage: params.sourceLanguage || undefined,
        targetLanguage: params.targetLanguage || undefined,
        text: params.text,
      },
    });
  }

  async detectLanguage(params: {
    provider: string;
    texts: string[];
  }): Promise<DetectLanguageResponseEnvelope> {
    return this.translationsApi.detectLanguage({
      provider: params.provider as 'iciba',
      detectLanguageRequest: {
        texts: params.texts,
      },
    });
  }

  async supportedLanguagePairs(params: {
    provider: string;
  }): Promise<LanguagePairListEnvelope> {
    return this.translationsApi.getSupportedLanguagePairs({
      provider: params.provider as 'iciba',
    });
  }

  async lookup(params: {
    provider: string;
    word: string;
    sourceLanguage: string;
    targetLanguage: string;
  }): Promise<LookUpResponseEnvelope> {
    return this.dictionariesApi.lookupDictionaryEntry({
      provider: params.provider as 'iciba',
      lookUpRequest: {
        sourceLanguage: params.sourceLanguage,
        targetLanguage: params.targetLanguage,
        word: params.word,
      },
    });
  }
}

export async function formatApiError(error: unknown) {
  if (isResponseError(error)) {
    const contentType = error.response.headers.get('content-type') ?? '';
    const body = contentType.includes('application/json')
      ? await error.response.json()
      : await error.response.text();

    return {
      status: error.response.status,
      statusText: error.response.statusText,
      body,
    };
  }

  if (error instanceof Error) {
    return {
      name: error.name,
      message: error.message,
    };
  }

  return error;
}

function isResponseError(error: unknown): error is ResponseError {
  return error instanceof ResponseError;
}
