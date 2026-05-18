import { useEffect, useMemo, useState } from 'react';
import type { ComponentProps } from 'react';
import {
  loadPageTranslationSettings,
  pageTranslationProviderOptions,
  savePageTranslationSettings,
} from '@/features/page-translation/settings';
import {
  type ContentRequest,
  type ContentResponse,
  pageTranslationMessageTypes,
} from '@/features/page-translation/messages';
import type {
  PageTranslationSettings,
  PageTranslationStatus,
  TranslationDisplayMode,
} from '@/features/page-translation/types';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

type PopupState = 'loading' | 'ready' | 'running' | 'error';

const idleStatus: PageTranslationStatus = {
  state: 'idle',
  translatedCount: 0,
  totalCount: 0,
  errorCount: 0,
  displayMode: 'bilingual',
};

function App() {
  const [settings, setSettings] = useState<PageTranslationSettings | null>(null);
  const [status, setStatus] = useState<PageTranslationStatus>(idleStatus);
  const [popupState, setPopupState] = useState<PopupState>('loading');
  const [error, setError] = useState<string | null>(null);

  const canRun = useMemo(
    () =>
      popupState !== 'loading' && popupState !== 'running' && settings != null,
    [popupState, settings],
  );

  useEffect(() => {
    let isMounted = true;

    async function loadInitialState() {
      try {
        const storedSettings = await loadPageTranslationSettings();

        if (!isMounted) {
          return;
        }

        setSettings(storedSettings);
        setPopupState('ready');

        try {
          const currentStatus = await sendToActiveTab({
            type: pageTranslationMessageTypes.getStatus,
          });

          if (!isMounted) {
            return;
          }

          if (currentStatus.ok) {
            setStatus(currentStatus.status);
          }
        } catch (statusError) {
          if (!isMounted) {
            return;
          }

          setError(getErrorMessage(statusError));
        }
      } catch (loadError) {
        if (!isMounted) {
          return;
        }

        setPopupState('error');
        setError(getErrorMessage(loadError));
      }
    }

    loadInitialState();

    return () => {
      isMounted = false;
    };
  }, []);

  async function updateSettings(nextSettings: PageTranslationSettings) {
    setSettings(nextSettings);
    await savePageTranslationSettings(nextSettings);
  }

  async function translatePage() {
    if (!settings) {
      return;
    }

    await runTabCommand({
      type: pageTranslationMessageTypes.translatePage,
      settings,
    });
  }

  async function restorePage() {
    await runTabCommand({ type: pageTranslationMessageTypes.restorePage });
  }

  async function runTabCommand(message: ContentRequest) {
    setPopupState('running');
    setError(null);

    try {
      const response = await sendToActiveTab(message);

      if (!response.ok) {
        throw new Error(response.error);
      }

      setStatus(response.status);
      setPopupState('ready');
    } catch (commandError) {
      setPopupState('error');
      setError(getErrorMessage(commandError));
    }
  }

  if (!settings) {
    return (
      <main className="w-[340px] p-4">
        <p className="text-sm text-muted-foreground">Loading...</p>
      </main>
    );
  }

  return (
    <main className="w-[340px] bg-background p-4 text-foreground">
      <Card>
        <CardHeader className="flex-row items-start justify-between gap-3">
          <div className="space-y-1">
            <p className="text-xs font-semibold text-muted-foreground uppercase">
              Beyond Translate
            </p>
            <CardTitle className="text-base">Page Translation</CardTitle>
          </div>
          <Badge variant={getStatusBadgeVariant(status.state)}>
            {status.state}
          </Badge>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="provider">Provider</Label>
            <select
              className="border-input bg-background ring-offset-background focus-visible:ring-ring h-9 w-full rounded-md border px-3 py-1 text-sm shadow-xs outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
              id="provider"
              onChange={(event) =>
                updateSettings({
                  ...settings,
                  provider: event.target.value,
                })
              }
              value={settings.provider}
            >
              {pageTranslationProviderOptions.map((provider) => (
                <option key={provider.id} value={provider.id}>
                  {provider.label}
                </option>
              ))}
            </select>
          </div>

          <div className="space-y-2">
            <Label htmlFor="target-language">Target language</Label>
            <Input
              id="target-language"
              onChange={(event) =>
                updateSettings({
                  ...settings,
                  targetLanguage: event.target.value,
                })
              }
              value={settings.targetLanguage}
            />
          </div>

          <div className="space-y-2">
            <Label>Display mode</Label>
            <div className="grid grid-cols-2 overflow-hidden rounded-md border">
              {(['bilingual', 'replace'] as TranslationDisplayMode[]).map(
                (mode) => (
                  <Button
                    aria-pressed={settings.displayMode === mode}
                    className="rounded-none border-0 first:border-r"
                    key={mode}
                    onClick={() =>
                      updateSettings({
                        ...settings,
                        displayMode: mode,
                      })
                    }
                    type="button"
                    variant={
                      settings.displayMode === mode ? 'default' : 'ghost'
                    }
                  >
                    {mode === 'bilingual' ? 'Bilingual' : 'Replace'}
                  </Button>
                ),
              )}
            </div>
          </div>

          <div className="grid grid-cols-3 gap-2">
            <Metric label="Translated" value={status.translatedCount} />
            <Metric label="Total" value={status.totalCount} />
            <Metric label="Errors" value={status.errorCount} />
          </div>

          {error || status.message ? (
            <p
              className={
                error
                  ? 'rounded-md bg-destructive/10 p-3 text-sm text-destructive'
                  : 'rounded-md bg-muted p-3 text-sm text-muted-foreground'
              }
            >
              {error ?? status.message}
            </p>
          ) : null}

          <div className="grid grid-cols-[1fr_1.2fr] gap-2">
            <Button
              disabled={popupState === 'running'}
              onClick={restorePage}
              type="button"
              variant="outline"
            >
              Restore
            </Button>
            <Button disabled={!canRun} onClick={translatePage} type="button">
              {popupState === 'running' ? 'Translating...' : 'Translate'}
            </Button>
          </div>
        </CardContent>
      </Card>
    </main>
  );
}

function Metric({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-md border bg-muted/40 p-2">
      <span className="block text-base font-semibold">{value}</span>
      <span className="block text-xs text-muted-foreground">{label}</span>
    </div>
  );
}

function getStatusBadgeVariant(
  state: PageTranslationStatus['state'],
): ComponentProps<typeof Badge>['variant'] {
  if (state === 'error') {
    return 'destructive';
  }

  if (state === 'translated') {
    return 'default';
  }

  return 'secondary';
}

async function sendToActiveTab(message: ContentRequest): Promise<ContentResponse> {
  const [tab] = await browser.tabs.query({
    active: true,
    currentWindow: true,
  });

  if (!tab?.id) {
    throw new Error('No active tab is available.');
  }

  return browser.tabs.sendMessage(tab.id, message) as Promise<ContentResponse>;
}

function getErrorMessage(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }

  return String(error);
}

export default App;
