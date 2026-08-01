# Contributor agent instructions (non-negotiable)

You are generating a **production-ready LenderLink contributor service** that:

1. Uploads hashed MSISDNs to LenderLink
2. Exposes (or documents) an inquiry API whose JSON result matches [person-data-response.md](person-data-response.md)—a Hit/No Hit object with a loan/application list using the same field names clients receive in Full Response loan records

## Must read first (in order)

1. [`../shared/openapi/swagger-public.json`](../shared/openapi/swagger-public.json) — LenderLink auth + MSISDN upload contract
2. [`getting-started.md`](getting-started.md)
3. [`authentication.md`](authentication.md)
4. [`person-data-response.md`](person-data-response.md) — **required response shape for your inquiry API**
5. [`hashing.md`](hashing.md)
6. [`msisdn-upload.md`](msisdn-upload.md)
7. [`../shared/phone-normalization.md`](../shared/phone-normalization.md)
8. [`../shared/errors.md`](../shared/errors.md)
9. Generation recipe: [`recipes/generate-contributor-uploader.md`](recipes/generate-contributor-uploader.md)

## Hard rules

1. Use only documented LenderLink base URLs for upload/auth. Never invent LenderLink hosts or paths.
2. Prefer `POST /oauth2/token` with `grant_type=client_credentials` **when calling LenderLink**.
3. Required scope for upload: `api:msisdn:write`.
4. **Normalize** then **hash locally** with SHA-512 (hex, 128 chars, lowercase) before upload.
5. Upload via `POST /api/v1/msisdns/batch` with body `{ "msisdns": [ ... ] }` (1–10000 items).
6. On HTTP `401` from LenderLink, re-authenticate once and retry once.
7. Treat HTTP `404` (no external API mapping) as a configuration problem, not a retryable upload error.
8. Inquiry API responses must use the top-level object and loan field names from `person-data-response.md`. Do not invent alternate KYC/loan attribute names.
9. Do **not** invent client-only fields (`summary`, `scores`) on the contributor response unless the user explicitly requires them.
10. Treat `matchFlag` `Hit` / `No Hit` correctly; empty `data` on No Hit is valid.
11. **Inquiry API authentication is contributor-defined.** Support (or document) Basic, Bearer, and/or a shared API key header as the user requests. Do not assume OAuth2 is required on the inquiry endpoint. Document how LenderLink should send credentials.
12. Never log raw MSISDNs in production code paths.
13. Env for LenderLink calls: `LENDERLINK_BASE_URL`, `LENDERLINK_CLIENT_ID`, `LENDERLINK_CLIENT_SECRET`.
14. Language-agnostic: implement in the language the user requests.

## Output contract

Deliver a runnable project with:

- README (setup, env, run)
- Auth module with token cache (for LenderLink upload)
- Normalize + hash utilities
- Batch uploader (chunk > 10000)
- Inquiry API (or clearly documented handler) that returns the person-data object
- Happy-path and error-path examples for both upload and inquiry
- `.env.example` without secrets

## Definition of done

Satisfy the checklist in [`recipes/generate-contributor-uploader.md`](recipes/generate-contributor-uploader.md) before finishing.
