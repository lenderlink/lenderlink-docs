# Contributor agent instructions (non-negotiable)

You are generating a **production-ready LenderLink contributor uploader**: HTTP client, OAuth2 auth, MSISDN normalization, SHA-512 hashing, and batch upload.

## Must read first (in order)

1. [`../shared/openapi/swagger-public.json`](../shared/openapi/swagger-public.json)
2. [`getting-started.md`](getting-started.md)
3. [`authentication.md`](authentication.md)
4. [`hashing.md`](hashing.md)
5. [`msisdn-upload.md`](msisdn-upload.md)
6. [`../shared/phone-normalization.md`](../shared/phone-normalization.md)
7. [`../shared/errors.md`](../shared/errors.md)
8. Generation recipe: [`recipes/generate-contributor-uploader.md`](recipes/generate-contributor-uploader.md)

## Hard rules

1. Use only documented base URLs. Never invent hosts or paths.
2. Prefer `POST /oauth2/token` with `grant_type=client_credentials`.
3. Required scope for upload: `api:msisdn:write`.
4. **Normalize** then **hash locally** with SHA-512 (hex, 128 chars, lowercase) before upload. Do not invent another hash algorithm.
5. Upload via `POST /api/v1/msisdns/batch` with body `{ "msisdns": [ ... ] }` (1–10000 items).
6. On HTTP `401`, re-authenticate once and retry once.
7. Treat HTTP `404` with message about no external API as a configuration problem (client not mapped as contributor), not a retryable upload error.
8. Never log raw MSISDNs in production code paths. Logging hashes only is acceptable.
9. Env config: `LENDERLINK_BASE_URL`, `LENDERLINK_CLIENT_ID`, `LENDERLINK_CLIENT_SECRET`.
10. Language-agnostic: implement in the language the user requests.

## Output contract

Deliver a runnable project with:

- README (setup, env, run)
- Auth module with token cache
- Normalize + hash utilities matching documented rules
- Batch uploader that chunks inputs larger than 10000
- Happy-path and error-path examples
- `.env.example` without secrets

## Definition of done

Satisfy the checklist in [`recipes/generate-contributor-uploader.md`](recipes/generate-contributor-uploader.md) before finishing.
