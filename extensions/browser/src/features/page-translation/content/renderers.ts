import type { TranslationDisplayMode } from '../types';
import type { ScannedSegment } from './dom-scanner';

export interface RenderedSegmentState {
  element: HTMLElement;
  originalHtml: string;
  translationElement?: HTMLElement;
}

export function injectPageTranslationStyles() {
  if (document.getElementById('beyondtranslate-page-translation-style')) {
    return;
  }

  const style = document.createElement('style');
  style.id = 'beyondtranslate-page-translation-style';
  style.textContent = `
    [data-beyondtranslate-translation] {
      box-sizing: border-box;
      margin: 0.35em 0 0;
      padding-inline-start: 0.75em;
      border-inline-start: 3px solid #0f766e;
      color: #0f766e;
      font: inherit;
      line-height: inherit;
      overflow-wrap: anywhere;
    }

    [data-beyondtranslate-state="translated"] {
      overflow-wrap: anywhere;
    }
  `;
  document.documentElement.append(style);
}

export function renderTranslation(params: {
  segment: ScannedSegment;
  translatedText: string;
  displayMode: TranslationDisplayMode;
  existingState?: RenderedSegmentState;
}): RenderedSegmentState {
  const { segment, translatedText, displayMode, existingState } = params;
  const originalHtml = existingState?.originalHtml ?? segment.element.innerHTML;

  if (existingState?.translationElement?.isConnected) {
    existingState.translationElement.remove();
  }

  segment.element.dataset.beyondtranslateState = 'translated';

  if (displayMode === 'replace') {
    segment.element.textContent = translatedText;
    return {
      element: segment.element,
      originalHtml,
    };
  }

  segment.element.innerHTML = originalHtml;

  const translationElement = document.createElement('div');
  translationElement.dataset.beyondtranslateTranslation = 'true';
  translationElement.textContent = translatedText;
  segment.element.insertAdjacentElement('afterend', translationElement);

  return {
    element: segment.element,
    originalHtml,
    translationElement,
  };
}

export function restoreRenderedSegment(state: RenderedSegmentState) {
  if (state.translationElement?.isConnected) {
    state.translationElement.remove();
  }

  state.element.innerHTML = state.originalHtml;
  delete state.element.dataset.beyondtranslateState;
}
