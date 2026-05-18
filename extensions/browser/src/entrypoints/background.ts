import {
  type BackgroundRequest,
  type BackgroundResponse,
  pageTranslationMessageTypes,
} from '@/features/page-translation/messages';
import { TranslationService } from '@/features/page-translation/background/translation-service';

const translationService = new TranslationService();

export default defineBackground(() => {
  browser.runtime.onMessage.addListener(
    async (message: BackgroundRequest): Promise<BackgroundResponse | undefined> => {
      if (message?.type !== pageTranslationMessageTypes.translateText) {
        return undefined;
      }

      try {
        const result = await translationService.translate(message.payload);
        return { ok: true, result };
      } catch (error) {
        return {
          ok: false,
          error: error instanceof Error ? error.message : String(error),
        };
      }
    },
  );
});
