import type { PageTranslationSettings } from './types';

const settingsKey = 'pageTranslationSettings';

export const pageTranslationProviderOptions = [
  { id: 'baidu', label: 'Baidu' },
  { id: 'iciba', label: 'Iciba' },
  { id: 'system', label: 'System' },
] as const;

export const defaultPageTranslationSettings: PageTranslationSettings = {
  baseUrl: 'http://localhost:8787',
  provider: 'baidu',
  targetLanguage: 'zh',
  displayMode: 'bilingual',
};

export async function loadPageTranslationSettings(): Promise<PageTranslationSettings> {
  const stored = await browser.storage.local.get(settingsKey);
  const value = stored[settingsKey] as Partial<PageTranslationSettings> | undefined;

  return normalizeSettings(value);
}

export async function savePageTranslationSettings(
  settings: PageTranslationSettings,
): Promise<PageTranslationSettings> {
  const normalized = normalizeSettings(settings);
  await browser.storage.local.set({ [settingsKey]: normalized });
  return normalized;
}

function normalizeSettings(
  value: Partial<PageTranslationSettings> | undefined,
): PageTranslationSettings {
  const baseUrl = value?.baseUrl?.trim() || defaultPageTranslationSettings.baseUrl;
  const provider = value?.provider?.trim() || defaultPageTranslationSettings.provider;
  const sourceLanguage = value?.sourceLanguage?.trim() || undefined;
  const targetLanguage =
    value?.targetLanguage?.trim() || defaultPageTranslationSettings.targetLanguage;

  return {
    baseUrl,
    provider,
    sourceLanguage,
    targetLanguage,
    displayMode:
      value?.displayMode === 'replace'
        ? 'replace'
        : defaultPageTranslationSettings.displayMode,
  };
}
