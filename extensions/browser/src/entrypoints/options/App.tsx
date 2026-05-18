import { useMemo, useState } from 'react';
import { ApiClientService, formatApiError } from '@/services/api-client';
import './App.css';

type EndpointId =
  | 'health'
  | 'translate'
  | 'detectLanguage'
  | 'supportedLanguagePairs'
  | 'lookup';

type RequestState = 'idle' | 'loading' | 'success' | 'error';

const defaultBaseUrl = 'http://localhost:8787';
const defaultProvider = 'iciba';

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
    <main className="options-page">
      <section className="debug-panel">
        <header className="debug-header">
          <div>
            <p className="eyebrow">Options</p>
            <h1>API Client Debugger</h1>
          </div>
          <button
            className="primary-button"
            disabled={requestState === 'loading'}
            onClick={runRequest}
            type="button"
          >
            {requestState === 'loading' ? 'Running...' : 'Run'}
          </button>
        </header>

        <div className="form-grid">
          <label className="field field-wide">
            <span>Base URL</span>
            <input
              onChange={(event) => setBaseUrl(event.target.value)}
              placeholder={defaultBaseUrl}
              value={baseUrl}
            />
          </label>

          <label className="field">
            <span>Provider</span>
            <input
              onChange={(event) => setProvider(event.target.value)}
              value={provider}
            />
          </label>

          <label className="field field-wide">
            <span>Endpoint</span>
            <select
              onChange={(event) => setEndpoint(event.target.value as EndpointId)}
              value={endpoint}
            >
              {endpointOptions.map((option) => (
                <option key={option.id} value={option.id}>
                  {option.label}
                </option>
              ))}
            </select>
          </label>

          <div className="endpoint-path">{selectedEndpoint.method}</div>

          {endpoint === 'translate' || endpoint === 'lookup' ? (
            <>
              <label className="field">
                <span>Source language</span>
                <input
                  onChange={(event) => setSourceLanguage(event.target.value)}
                  value={sourceLanguage}
                />
              </label>

              <label className="field">
                <span>Target language</span>
                <input
                  onChange={(event) => setTargetLanguage(event.target.value)}
                  value={targetLanguage}
                />
              </label>
            </>
          ) : null}

          {endpoint === 'translate' ? (
            <label className="field field-wide">
              <span>Text</span>
              <textarea
                onChange={(event) => setText(event.target.value)}
                rows={4}
                value={text}
              />
            </label>
          ) : null}

          {endpoint === 'detectLanguage' ? (
            <label className="field field-wide">
              <span>Texts</span>
              <textarea
                onChange={(event) => setTexts(event.target.value)}
                rows={5}
                value={texts}
              />
            </label>
          ) : null}

          {endpoint === 'lookup' ? (
            <label className="field field-wide">
              <span>Word</span>
              <input
                onChange={(event) => setWord(event.target.value)}
                value={word}
              />
            </label>
          ) : null}
        </div>
      </section>

      <section className="result-panel">
        <div className="result-toolbar">
          <h2>Response</h2>
          <span className={`status-badge status-${requestState}`}>
            {requestState}
          </span>
        </div>
        <pre>{result == null ? 'No request has been run.' : JSON.stringify(result, null, 2)}</pre>
      </section>
    </main>
  );
}

export default App;
