import { ApiClientService, formatApiError } from '@/services/api-client';
import type { TranslateTextPayload, TranslateTextResult } from '../types';

const maxConcurrentRequests = 3;
const cacheLimit = 500;

export class TranslationService {
  private activeRequests = 0;
  private readonly queue: Array<() => void> = [];
  private readonly cache = new Map<string, TranslateTextResult>();
  private readonly clients = new Map<string, ApiClientService>();

  async translate(payload: TranslateTextPayload): Promise<TranslateTextResult> {
    const key = this.createCacheKey(payload);
    const cached = this.cache.get(key);

    if (cached) {
      return cached;
    }

    return this.enqueue(async () => {
      const cachedAfterWait = this.cache.get(key);

      if (cachedAfterWait) {
        return cachedAfterWait;
      }

      try {
        const response = await this.getClient(payload.baseUrl).translate({
          provider: payload.provider,
          text: payload.text,
          sourceLanguage: payload.sourceLanguage,
          targetLanguage: payload.targetLanguage,
        });
        const translation = response.data.translations[0];

        if (!translation?.text) {
          throw new Error('Translation response did not include translated text.');
        }

        const result: TranslateTextResult = {
          text: translation.text,
          detectedSourceLanguage: translation.detectedSourceLanguage,
        };
        this.remember(key, result);
        return result;
      } catch (error) {
        const formatted = await formatApiError(error);
        throw new Error(formatBackgroundError(formatted));
      }
    });
  }

  private async enqueue<T>(task: () => Promise<T>): Promise<T> {
    if (this.activeRequests >= maxConcurrentRequests) {
      await new Promise<void>((resolve) => this.queue.push(resolve));
    }

    this.activeRequests += 1;

    try {
      return await task();
    } finally {
      this.activeRequests -= 1;
      this.queue.shift()?.();
    }
  }

  private getClient(baseUrl: string): ApiClientService {
    const normalizedBaseUrl = baseUrl.replace(/\/+$/, '');
    const existing = this.clients.get(normalizedBaseUrl);

    if (existing) {
      return existing;
    }

    const client = new ApiClientService(normalizedBaseUrl);
    this.clients.set(normalizedBaseUrl, client);
    return client;
  }

  private remember(key: string, result: TranslateTextResult) {
    if (this.cache.size >= cacheLimit) {
      const firstKey = this.cache.keys().next().value as string | undefined;

      if (firstKey) {
        this.cache.delete(firstKey);
      }
    }

    this.cache.set(key, result);
  }

  private createCacheKey(payload: TranslateTextPayload): string {
    return [
      payload.baseUrl.replace(/\/+$/, ''),
      payload.provider,
      payload.sourceLanguage ?? '',
      payload.targetLanguage,
      payload.text,
    ].join('\u0001');
  }
}

function formatBackgroundError(error: unknown): string {
  if (typeof error === 'string') {
    return error;
  }

  if (
    error &&
    typeof error === 'object' &&
    'message' in error &&
    typeof error.message === 'string'
  ) {
    return error.message;
  }

  return JSON.stringify(error);
}
