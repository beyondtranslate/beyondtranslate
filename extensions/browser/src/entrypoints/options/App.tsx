import { useMemo, useState } from 'react';
import type { ComponentProps } from 'react';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { ApiClientService, formatApiError } from '@/services/api-client';

type EndpointId =
  | 'health'
  | 'translate'
  | 'detectLanguage'
  | 'supportedLanguagePairs'
  | 'lookup';

type RequestState = 'idle' | 'loading' | 'success' | 'error';

const defaultBaseUrl = 'http://localhost:8787';
const defaultProvider = 'baidu';

const endpointOptions: Array<{ id: EndpointId; label: string; method: string }> =
  [
    { id: 'health', label: 'Health check', method: 'GET /health' },
    {
      id: 'translate',
      label: 'Translate text',
      method: 'POST /translations/{provider}/translate',
    },
    {
      id: 'detectLanguage',
      label: 'Detect language',
      method: 'POST /translations/{provider}/detect-language',
    },
    {
      id: 'supportedLanguagePairs',
      label: 'Supported language pairs',
      method: 'GET /translations/{provider}/supported-language-pairs',
    },
    {
      id: 'lookup',
      label: 'Dictionary lookup',
      method: 'POST /dictionaries/{provider}/lookup',
    },
  ];

function getStoredValue(key: string, fallback: string) {
  try {
    return localStorage.getItem(key) ?? fallback;
  } catch {
    return fallback;
  }
}

function setStoredValue(key: string, value: string) {
  try {
    localStorage.setItem(key, value);
  } catch {
    // Ignore storage failures in restricted extension contexts.
  }
}

function App() {
  const [baseUrl, setBaseUrl] = useState(() =>
    getStoredValue('debugApiBaseUrl', defaultBaseUrl),
  );
  const [provider, setProvider] = useState(() =>
    getStoredValue('debugApiProvider', defaultProvider),
  );
  const [endpoint, setEndpoint] = useState<EndpointId>('health');
  const [sourceLanguage, setSourceLanguage] = useState('en');
  const [targetLanguage, setTargetLanguage] = useState('zh');
  const [text, setText] = useState('hello');
  const [word, setWord] = useState('hello');
  const [texts, setTexts] = useState('hello\nbonjour');
  const [requestState, setRequestState] = useState<RequestState>('idle');
  const [result, setResult] = useState<unknown>(null);

  const selectedEndpoint = useMemo(
    () => endpointOptions.find((option) => option.id === endpoint)!,
    [endpoint],
  );

  async function runRequest() {
    setStoredValue('debugApiBaseUrl', baseUrl);
    setStoredValue('debugApiProvider', provider);
    setRequestState('loading');
    setResult(null);

    const client = new ApiClientService(baseUrl);

    try {
      let response: unknown;

      switch (endpoint) {
        case 'health':
          response = await client.health();
          break;
        case 'translate':
          response = await client.translate({
            provider,
            text,
            sourceLanguage: sourceLanguage || undefined,
            targetLanguage: targetLanguage || undefined,
          });
          break;
        case 'detectLanguage':
          response = await client.detectLanguage({
            provider,
            texts: texts
              .split('\n')
              .map((value) => value.trim())
              .filter(Boolean),
          });
          break;
        case 'supportedLanguagePairs':
          response = await client.supportedLanguagePairs({ provider });
          break;
        case 'lookup':
          response = await client.lookup({
            provider,
            word,
            sourceLanguage,
            targetLanguage,
          });
          break;
      }

      setRequestState('success');
      setResult(response);
    } catch (error) {
      setRequestState('error');
      setResult(await formatApiError(error));
    }
  }

  return (
    <main className="min-h-screen bg-muted/40 px-6 py-8 text-foreground">
      <div className="mx-auto grid w-full max-w-6xl gap-6">
        <Card>
          <CardHeader className="flex-row items-start justify-between gap-4">
          <div>
              <CardDescription>Options</CardDescription>
              <CardTitle className="text-2xl">API Client Debugger</CardTitle>
          </div>
            <Button
            disabled={requestState === 'loading'}
            onClick={runRequest}
            type="button"
          >
            {requestState === 'loading' ? 'Running...' : 'Run'}
            </Button>
          </CardHeader>

          <CardContent className="grid grid-cols-1 gap-4 md:grid-cols-2">
            <div className="space-y-2 md:col-span-2">
              <Label htmlFor="base-url">Base URL</Label>
              <Input
                id="base-url"
              onChange={(event) => setBaseUrl(event.target.value)}
              placeholder={defaultBaseUrl}
              value={baseUrl}
            />
            </div>

            <div className="space-y-2">
              <Label htmlFor="provider">Provider</Label>
              <Input
                id="provider"
              onChange={(event) => setProvider(event.target.value)}
              value={provider}
            />
            </div>

            <div className="space-y-2">
              <Label htmlFor="endpoint">Endpoint</Label>
            <select
                className="border-input bg-background ring-offset-background focus-visible:ring-ring h-9 w-full rounded-md border px-3 py-1 text-sm shadow-xs outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
                id="endpoint"
              onChange={(event) => setEndpoint(event.target.value as EndpointId)}
              value={endpoint}
            >
              {endpointOptions.map((option) => (
                <option key={option.id} value={option.id}>
                  {option.label}
                </option>
              ))}
            </select>
            </div>

            <div className="rounded-md border bg-muted px-3 py-2 font-mono text-sm text-muted-foreground md:col-span-2">
              {selectedEndpoint.method}
            </div>

          {endpoint === 'translate' || endpoint === 'lookup' ? (
            <>
                <div className="space-y-2">
                  <Label htmlFor="source-language">Source language</Label>
                  <Input
                    id="source-language"
                  onChange={(event) => setSourceLanguage(event.target.value)}
                  value={sourceLanguage}
                />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="target-language">Target language</Label>
                  <Input
                    id="target-language"
                  onChange={(event) => setTargetLanguage(event.target.value)}
                  value={targetLanguage}
                />
                </div>
            </>
          ) : null}

          {endpoint === 'translate' ? (
              <div className="space-y-2 md:col-span-2">
                <Label htmlFor="text">Text</Label>
                <Textarea
                  id="text"
                onChange={(event) => setText(event.target.value)}
                rows={4}
                value={text}
              />
              </div>
          ) : null}

          {endpoint === 'detectLanguage' ? (
              <div className="space-y-2 md:col-span-2">
                <Label htmlFor="texts">Texts</Label>
                <Textarea
                  id="texts"
                onChange={(event) => setTexts(event.target.value)}
                rows={5}
                value={texts}
              />
              </div>
          ) : null}

          {endpoint === 'lookup' ? (
              <div className="space-y-2 md:col-span-2">
                <Label htmlFor="word">Word</Label>
                <Input
                  id="word"
                onChange={(event) => setWord(event.target.value)}
                value={word}
              />
              </div>
          ) : null}
          </CardContent>
        </Card>

        <Card className="overflow-hidden">
          <CardHeader className="flex-row items-center justify-between">
            <CardTitle className="text-base">Response</CardTitle>
            <Badge variant={getRequestBadgeVariant(requestState)}>
              {requestState}
            </Badge>
          </CardHeader>
          <CardContent>
            <pre className="max-h-[480px] min-h-44 overflow-auto rounded-md bg-slate-950 p-4 text-left text-sm leading-6 whitespace-pre-wrap text-slate-100">
              {result == null
                ? 'No request has been run.'
                : JSON.stringify(result, null, 2)}
            </pre>
          </CardContent>
        </Card>
      </div>
    </main>
  );
}

function getRequestBadgeVariant(
  state: RequestState,
): ComponentProps<typeof Badge>['variant'] {
  if (state === 'error') {
    return 'destructive';
  }

  if (state === 'success') {
    return 'default';
  }

  return 'secondary';
}

export default App;
