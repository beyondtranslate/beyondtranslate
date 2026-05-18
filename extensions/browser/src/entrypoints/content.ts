import {
  type ContentRequest,
  type ContentResponse,
  pageTranslationMessageTypes,
} from '@/features/page-translation/messages';
import { PageTranslator } from '@/features/page-translation/content/page-translator';

const translator = new PageTranslator();

export default defineContentScript({
  matches: ['<all_urls>'],
  main() {
    browser.runtime.onMessage.addListener(
      async (message: ContentRequest): Promise<ContentResponse | undefined> => {
        if (!message?.type) {
          return undefined;
        }

        try {
          switch (message.type) {
            case pageTranslationMessageTypes.getStatus:
              return { ok: true, status: translator.getStatus() };
            case pageTranslationMessageTypes.translatePage:
              return {
                ok: true,
                status: await translator.translate(message.settings),
              };
            case pageTranslationMessageTypes.restorePage:
              return { ok: true, status: translator.restore() };
            default:
              return undefined;
          }
        } catch (error) {
          return {
            ok: false,
            error: error instanceof Error ? error.message : String(error),
            status: translator.getStatus(),
          };
        }
      },
    );
  },
});
