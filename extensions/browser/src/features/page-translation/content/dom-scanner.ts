import type { TranslationSegment } from '../types';

const candidateSelector = [
  'article',
  'main',
  'section',
  'p',
  'li',
  'blockquote',
  'figcaption',
  'td',
  'th',
  'dt',
  'dd',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
].join(',');

const nestedBlockSelector = [
  'article',
  'main',
  'section',
  'p',
  'li',
  'blockquote',
  'figcaption',
  'td',
  'th',
  'dt',
  'dd',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
].join(',');

const excludedSelector = [
  'script',
  'style',
  'noscript',
  'textarea',
  'input',
  'select',
  'option',
  'svg',
  'canvas',
  'code',
  'pre',
  '[contenteditable="true"]',
  '[data-beyondtranslate-translation]',
].join(',');

export interface ScannedSegment extends TranslationSegment {
  element: HTMLElement;
}

export function scanPageSegments(): ScannedSegment[] {
  const elements = Array.from(
    document.body.querySelectorAll<HTMLElement>(candidateSelector),
  );
  const segments: ScannedSegment[] = [];
  const seenTexts = new Set<string>();

  for (const element of elements) {
    if (!isEligibleElement(element)) {
      continue;
    }

    const text = normalizeText(element.innerText || element.textContent || '');

    if (!isEligibleText(text) || seenTexts.has(text)) {
      continue;
    }

    seenTexts.add(text);
    segments.push({
      id: `bt-segment-${segments.length + 1}`,
      element,
      text,
    });
  }

  return segments;
}

function isEligibleElement(element: HTMLElement): boolean {
  if (element.closest(excludedSelector)) {
    return false;
  }

  if (element.dataset.beyondtranslateState === 'translated') {
    return false;
  }

  if (!isVisible(element)) {
    return false;
  }

  const childBlocks = Array.from(
    element.querySelectorAll<HTMLElement>(nestedBlockSelector),
  ).filter((child) => child !== element && isVisible(child));

  return childBlocks.length === 0;
}

function isVisible(element: HTMLElement): boolean {
  const style = window.getComputedStyle(element);

  if (
    style.display === 'none' ||
    style.visibility === 'hidden' ||
    style.opacity === '0'
  ) {
    return false;
  }

  const rect = element.getBoundingClientRect();
  return rect.width > 0 && rect.height > 0;
}

function isEligibleText(text: string): boolean {
  if (text.length < 2 || text.length > 4000) {
    return false;
  }

  if (!/[A-Za-z\u00c0-\u024f\u4e00-\u9fff]/.test(text)) {
    return false;
  }

  return true;
}

function normalizeText(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}
