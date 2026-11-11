import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

function logWorkerProxy(proxy) {
  proxy.on('proxyReq', (_proxyRequest, request) => {
    console.log(`[AI PROXY] ${request.method} ${request.url} -> Worker :8806`);
  });
  proxy.on('proxyRes', (proxyResponse, request) => {
    console.log(`[AI PROXY] ${request.method} ${request.url} <- ${proxyResponse.statusCode}`);
  });
  proxy.on('error', (error, request) => {
    console.error(`[AI PROXY ERROR] ${request?.method || 'request'} ${request?.url || ''}: ${error.message}`);
    console.error('Confirm the Concept Compass Worker is running on http://127.0.0.1:8806.');
  });
}

const workerProxy = {
  target: 'http://127.0.0.1:8806',
  changeOrigin: false,
  configure: logWorkerProxy,
};

// Same-origin proxy avoids CORS/port drift. Strict port prevents silently
// opening a different site if port 5199 is already occupied.
export default defineConfig({
  plugins: [react()],
  server: {
    host: '127.0.0.1',
    port: 5199,
    strictPort: true,
    proxy: {
      '/api': { ...workerProxy },
      '/health': { ...workerProxy },
    },
  },
});
