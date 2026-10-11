// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — PWA Service Worker (v7 Rock-Solid)
// Strategy: Network-First for Navigation (Instant Mobile Sync & Fresh HTML)
// Fallback: Cache-First for Assets, Offline Reader Resilience
// =====================================================================

const CACHE_NAME = 'smritir-canvas-v7-unified';
const STATIC_ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './icon-192.png',
  './icon-512.png'
];

// 1. Install: Pre-cache core assets and activate immediately
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS).catch((err) => console.log('[SW] Pre-cache non-fatal:', err));
    })
  );
  self.skipWaiting();
});

// 2. Activate: Wipe ALL outdated cache versions so mobile loads newest files
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            console.log('[SW] Wiping obsolete cache:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// 3. Message handler: Allow client page to trigger immediate cache purge
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  if (event.data && event.data.type === 'CLEAR_CACHE') {
    caches.keys().then((keys) => {
      keys.forEach((key) => caches.delete(key));
    });
  }
});

// 4. Fetch: NETWORK-FIRST for HTML/navigation so mobile refresh ALWAYS gets fresh code!
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  const url = new URL(event.request.url);
  const isNavigation = event.request.mode === 'navigate' ||
                       event.request.destination === 'document' ||
                       url.pathname.endsWith('.html') ||
                       url.pathname.endsWith('/');

  if (isNavigation) {
    // ALWAYS fetch latest from network first
    event.respondWith(
      fetch(event.request)
        .then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200) {
            const cloned = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, cloned));
          }
          return networkResponse;
        })
        .catch(() => {
          // If offline, serve cached version
          return caches.match(event.request).then((cached) => {
            return cached || caches.match('./index.html') || caches.match('/');
          });
        })
    );
    return;
  }

  // Stale-While-Revalidate for icons and static resources
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      const fetchPromise = fetch(event.request)
        .then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200) {
            const cloned = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, cloned));
          }
          return networkResponse;
        })
        .catch(() => null);

      return cachedResponse || fetchPromise;
    })
  );
});
