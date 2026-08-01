# Recipe: generate a contributor uploader service

Follow this sequence exactly when generating code from these docs.

## 1. Confirm inputs from the user

- Target language
- Environment (sandbox vs production)
- Input source (CSV file, stdin, API, …)
- Credentials availability (`client_id` / `client_secret` with `api:msisdn:write`)

## 2. Read contracts

1. `shared/openapi/swagger-public.json`
2. `contributors/AGENTS.md`
3. `contributors/authentication.md`
4. `contributors/hashing.md`
5. `contributors/msisdn-upload.md`
6. `shared/phone-normalization.md` and `shared/errors.md`

## 3. Scaffold project

```text
README.md
.env.example
src/
  config.ext
  auth.ext
  normalize.ext    # PH MSISDN → 63##########
  hash.ext         # SHA-512 hex lowercase
  upload.ext       # POST /api/v1/msisdns/batch with chunking
  main.ext
examples/
  happy-path.ext
  error-path.ext
```

## 4. Implement pipeline

1. Auth: `POST /oauth2/token` (`client_credentials`), cache token
2. For each input MSISDN: normalize → SHA-512 hex
3. Chunk hashes into batches of max 10000
4. `POST /api/v1/msisdns/batch` with `{ "msisdns": [...] }`
5. Handle 401 (re-auth once), 404 mapping error (fail loudly), 400 validation

## 5. Security

- Never write raw MSISDNs to production logs
- Prefer logging batch sizes and hash counts only
- Keep hashing demo inputs out of committed production configs

## 6. Examples

- Happy path: hash one normalized number and upload a single-item batch; print `count`
- Error path: empty `msisdns` array or invalid auth demonstrating the error envelope

## 7. Definition of done checklist

- [ ] Uses only documented endpoints
- [ ] Env-based config; `.env.example` present; no secrets committed
- [ ] OAuth2 `client_credentials` via `/oauth2/token`
- [ ] Normalization matches `shared/phone-normalization.md`
- [ ] Hashing is SHA-512 hex of digits-only normalized MSISDN (128 chars)
- [ ] Batch size capped at 10000 with chunking for larger inputs
- [ ] 401 single re-auth + retry; 404 mapping treated as fatal config error
- [ ] README documents scope `api:msisdn:write` and run steps
- [ ] Happy-path and error-path examples included
- [ ] No production logging of raw MSISDNs
