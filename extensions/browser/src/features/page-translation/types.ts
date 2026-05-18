export type TranslationDisplayMode = 'bilingual' | 'replace';

export type PageTranslationState =
  | 'idle'
  | 'translating'
  | 'translated'
  | 'error';

export interface PageTranslationSettings {
  baseUrl: string;
  provider: string;
  sourceLanguage?: string;
  targetLanguage: string;
  displayMode: TranslationDisplayMode;
}

export interface PageTranslationStatus {
  state: PageTranslationState;
  translatedCount: number;
  totalCount: number;
  errorCount: number;
  displayMode: TranslationDisplayMode;
  message?: string;
}

export interface TranslationSegment {
  id: string;
  text: string;
}

export interface TranslateTextPayload {
  provider: string;
  baseUrl: string;
  text: string;
  sourceLanguage?: string;
  targetLanguage: string;
}

export interface TranslateTextResult {
  text: string;
  detectedSourceLanguage?: string;
}
