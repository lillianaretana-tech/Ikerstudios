// Cartera 24 TEST: no se almacena información financiera ni autenticación en caché.
self.addEventListener('install', e => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  if (event.request.method !== 'GET' || url.origin !== self.location.origin) return;
  // Siempre consultar la versión vigente. No guardar respuestas.
  event.respondWith(fetch(event.request));
});
