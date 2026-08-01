# Recipe: generate a contributor service

Follow this sequence when generating code from these docs.

## 1. Confirm inputs from the user

- Target language
- Environment (sandbox vs production) for LenderLink upload
- Whether to implement MSISDN upload, inquiry API, or both (default: **both**)
- Input source for MSISDN upload (CSV, stdin, …)
- Credentials (`client_id` / `client_secret` with `api:msisdn:write`)

## 2. Read contracts

1. `shared/openapi/swagger-public.json`
2. `contributors/AGENTS.md`
3. `contributors/authentication.md`
4. `contributors/person-data-response.md` ← inquiry response shape
5. `contributors/hashing.md`
6. `contributors/msisdn-upload.md`
7. `shared/phone-normalization.md` and `shared/errors.md`

## 3. Scaffold project

```text
README.md
.env.example
src/
  config.ext
  auth.ext              # LenderLink token cache
  normalize.ext         # PH MSISDN → 63##########
  hash.ext              # SHA-512 hex lowercase
  upload.ext            # POST /api/v1/msisdns/batch
  inquiry/
    handler.ext         # person lookup → person-data-response object
    models.ext          # loan record fields
  main.ext
examples/
  upload-happy-path.ext
  upload-error-path.ext
  inquiry-hit.ext
  inquiry-no-hit.ext
```

## 4. Implement MSISDN upload (to LenderLink)

1. Auth: `POST /oauth2/token` (`client_credentials`), cache token
2. For each input MSISDN: normalize → SHA-512 hex
3. Chunk hashes into batches of max 10000
4. `POST /api/v1/msisdns/batch`
5. Handle 401 (re-auth once), 404 mapping error (fatal), 400 validation

## 5. Implement inquiry API (your service)

1. Accept a person lookup (phone, name, DOB, optional email/id, request id)—exact wiring is env/config
2. Protect the endpoint with **contributor-chosen** auth (ask the user which): HTTP Basic, Bearer token, and/or a shared API key header. Document header names and how LenderLink should send credentials. Do not force OAuth2 on this endpoint.
3. Look up loans/applications in the contributor’s data store
4. Return JSON matching `person-data-response.md`:
   - `requestId`, optional `cellphoneNumber`
   - `matchFlag`: `Hit` or `No Hit`
   - `data`: array of loan records with documented KYC + `loanInfo*` fields
5. On no records: `matchFlag: "No Hit"`, `data: []`
6. Do not add `summary` / `scores` unless explicitly requested

## 6. Security

- Never write raw MSISDNs to production logs
- Prefer logging batch sizes and hash counts for upload
- Share only fields allowed under the contributor agreement

## 7. Examples

- Upload happy path: hash one number, upload, print `count`
- Upload error path: empty batch or bad auth
- Inquiry hit: return fixture-shaped object with ≥1 loan
- Inquiry no-hit: empty `data`

## 8. Definition of done checklist

- [ ] LenderLink calls use only documented endpoints
- [ ] Env-based config; `.env.example` present; no secrets committed
- [ ] OAuth2 `client_credentials` via `/oauth2/token`
- [ ] Normalization matches `shared/phone-normalization.md`
- [ ] Hashing is SHA-512 hex of digits-only normalized MSISDN (128 chars)
- [ ] Batch size capped at 10000 with chunking
- [ ] 401 single re-auth + retry; 404 mapping treated as fatal
- [ ] Inquiry endpoint uses contributor-defined auth (Basic / Bearer / API key header as requested); README tells LenderLink what to send
- [ ] Inquiry response matches `person-data-response.md` field names
- [ ] Hit / No Hit handled; empty `data` on No Hit
- [ ] No client-only `summary` / `scores` unless requested
- [ ] README covers upload scope `api:msisdn:write` and inquiry response shape
- [ ] Happy-path and error-path examples for upload and inquiry
- [ ] No production logging of raw MSISDNs
