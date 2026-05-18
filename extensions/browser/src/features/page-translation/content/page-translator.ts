import {
  type BackgroundResponse,
  pageTranslationMessageTypes,
} from '../messages';
import type {
  PageTranslationSettings,
  PageTranslationStatus,
  TranslateTextResult,
} from '../types';
import { scanPageSegments, type ScannedSegment } from './dom-scanner';
import {
  injectPageTranslationStyles,
  renderTranslation,
  type RenderedSegmentState,
  restoreRenderedSegment,
} from './renderers';

export class PageTranslator {
  private status: PageTranslationStatus = {
    state: 'idle',
    translatedCount: 0,
    totalCount: 0,
    errorCount: 0,
    displayMode: 'bilingual',
  };
  private readonly renderedSegments = new Map<HTMLElement, RenderedSegmentState>();
  private runId = 0;

  getStatus(): PageTranslationStatus {
    return { ...this.status };
  }

  async translate(settings: PageTranslationSettings): Promise<PageTranslationStatus> {
    const currentRunId = this.runId + 1;
    this.runId = currentRunId;
    this.restoreRenderedSegments();
    injectPageTranslationStyles();

    const segments = scanPageSegments();
    this.status = {
      state: 'translating',
      translatedCount: 0,
      totalCount: segments.length,
      errorCount: 0,
      displayMode: settings.displayMode,
    };

    if (segments.length === 0) {
      this.status = {
        ...this.status,
        state: 'translated',
        message: 'No translatable text was found on this page.',
      };
      return this.getStatus();
    }

    for (const segment of segments) {
      if (this.runId !== currentRunId) {
        break;
      }

      try {
        const result = await translateSegment(segment, settings);
        const existingState = this.renderedSegments.get(segment.element);
        const renderedState = renderTranslation({
          segment,
          translatedText: result.text,
          displayMode: settings.displayMode,
          existingState,
        });

        this.renderedSegments.set(segment.element, renderedState);
        this.status = {
          ...this.status,
          translatedCount: this.status.translatedCount + 1,
        };
      } catch (error) {
        this.status = {
          ...this.status,
          errorCount: this.status.errorCount + 1,
          message: error instanceof Error ? error.message : String(error),
        };
      }
    }

    if (this.runId === currentRunId) {
      this.status = {
        ...this.status,
        state: this.status.translatedCount > 0 ? 'translated' : 'error',
      };
    }

    return this.getStatus();
  }

  restore(): PageTranslationStatus {
    this.runId += 1;
    this.restoreRenderedSegments();
    this.status = {
      state: 'idle',
      translatedCount: 0,
      totalCount: 0,
      errorCount: 0,
      displayMode: this.status.displayMode,
    };

    return this.getStatus();
  }

  private restoreRenderedSegments() {
    for (const state of this.renderedSegments.values()) {
      restoreRenderedSegment(state);
    }

    this.renderedSegments.clear();
  }
}

async function translateSegment(
  segment: ScannedSegment,
  settings: PageTranslationSettings,
): Promise<TranslateTextResult> {
  const response = (await browser.runtime.sendMessage({
    type: pageTranslationMessageTypes.translateText,
    payload: {
      baseUrl: settings.baseUrl,
      provider: settings.provider,
      sourceLanguage: settings.sourceLanguage,
      targetLanguage: settings.targetLanguage,
      text: segment.text,
    },
  })) as BackgroundResponse;

  if (!response?.ok) {
    throw new Error(response?.error || 'Translation failed.');
  }

  return response.result;
}
