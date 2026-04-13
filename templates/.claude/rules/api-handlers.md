---
paths:
  - "src/**/*.js"
---

# API Handler Rules

- Validate all request inputs with zod before processing.
- Return generic error messages to clients; log full details with pino.
- Set security headers on every response (CSP, X-Frame-Options, HSTS, etc.).
- Keep route handlers thin — delegate to service-layer functions.
- Never call the data layer directly from a route handler.
