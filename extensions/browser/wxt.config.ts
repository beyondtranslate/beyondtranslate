import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'wxt';

// See https://wxt.dev/api/config.html
export default defineConfig({
  srcDir: 'src',
  modules: ['@wxt-dev/module-react'],
  vite: () => ({
    plugins: [tailwindcss()],
  }),
  manifest: {
    name: 'Beyond Translate',
    permissions: ['storage', 'activeTab'],
    host_permissions: ['http://localhost/*', 'http://127.0.0.1/*'],
  },
});
