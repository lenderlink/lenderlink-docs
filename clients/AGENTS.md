# Client agent instructions (non-negotiable)

You are generating a **production-ready LenderLink client integration service**: HTTP client, OAuth2 auth, and at least one person product API.

## Must read first (in order)

1. [`../shared/openapi/swagger-public.json`](../shared/openapi/swagger-public.json) — contract source of truth
2. [`getting-started.md`](getting-started.md)
3. [`authentication.md`](authentication.md)
4. [`scopes-and-products.md`](scopes-and-products.md)
5. The specific product page under [`apis/`](apis/) that the user requested
6. [`../shared/phone-normalization.md`](../shared/phone-normalization.md)
7. [`../shared/errors.md`](../shared/errors.md)
8. Generation recipe: [`recipes/generate-client-service.md`](recipes/generate-client-service.md)

## Hard rules

1. Use only documented base URLs from [`../shared/environments.md`](../shared/environments.md). Never invent hosts or paths.
2. Never invent endpoints, fields, scopes, or response shapes. If unsure, follow OpenAPI + these docs.
3. Prefer `POST /oauth2/token` with `grant_type=client_credentials` for server-to-server services.
4. Send `Authorization: Bearer <access_token>` on all product calls.
5. On HTTP `401`, re-authenticate once and retry the product call once.
6. Normalize Philippines phones before send (`63` + 10 digits). See phone-normalization.md.
7. Treat `matchFlag` as `"Hit"` or `"No Hit"`. Empty `data` with `"No Hit"` is a valid success.
8. Use env config: `LENDERLINK_BASE_URL`, `LENDERLINK_CLIENT_ID`, `LENDERLINK_CLIENT_SECRET` (aliases `CLIENT_ID` / `CLIENT_SECRET` acceptable).
9. Do not hard-code secrets. Do not commit credentials.
10. Language is agnostic: implement in the language the user asks for (Node, Python, Java, Go, PHP, etc.).

## Output contract

Deliver a runnable project that includes:

- README with setup, env vars, and run commands
- Auth module that fetches and caches the access token until near expiry
- Client module for the requested product(s)
- One happy-path example and one error-path example (e.g. 400 validation)
- `.env.example` without real secrets

## Definition of done

Before finishing, verify every item in the checklist in [`recipes/generate-client-service.md`](recipes/generate-client-service.md).
