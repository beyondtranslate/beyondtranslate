import { defineConfig } from 'wxt';

// See https://wxt.dev/api/config.html
export default defineConfig({
  srcDir: 'src',
  modules: ['@wxt-dev/module-react'],
  manifest: {
    name: 'Beyond Translate',
    host_permissions: ['http://localhost/*', 'http://127.0.0.1/*'],
  },
});
