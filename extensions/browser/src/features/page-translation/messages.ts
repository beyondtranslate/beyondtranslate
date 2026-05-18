import type {
  PageTranslationSettings,
  PageTranslationStatus,
  TranslateTextPayload,
  TranslateTextResult,
} from './types';

export const pageTranslationMessageTypes = {
  getStatus: 'page-translation:get-status',
  translatePage: 'page-translation:translate-page',
  restorePage: 'page-translation:restore-page',
  translateText: 'page-translation:translate-text',
} as const;

export type ContentRequest =
  | { type: typeof pageTranslationMessageTypes.getStatus }
  | {
      type: typeof pageTranslationMessageTypes.translatePage;
      settings: PageTranslationSettings;
    }
  | { type: typeof pageTranslationMessageTypes.restorePage };

export type ContentResponse =
  | { ok: true; status: PageTranslationStatus }
  | { ok: false; error: string; status?: PageTranslationStatus };

export type BackgroundRequest = {
  type: typeof pageTranslationMessageTypes.translateText;
  payload: TranslateTextPayload;
};

export type BackgroundResponse =
  | { ok: true; result: TranslateTextResult }
  | { ok: false; error: string };
