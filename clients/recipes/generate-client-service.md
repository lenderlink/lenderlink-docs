# Recipe: generate a client integration service

Follow this sequence exactly when generating code from these docs.

## 1. Confirm inputs from the user

- Target language (Node, Python, Java, Go, PHP, …)
- Environment (sandbox vs production base URL)
- Product(s) to implement (default: Full Response)
- Whether they already have `client_id` / `client_secret`

## 2. Read contracts

1. `shared/openapi/swagger-public.json`
2. `clients/AGENTS.md`
3. `clients/authentication.md`
4. Relevant `clients/apis/*.md`
5. `shared/phone-normalization.md` and `shared/errors.md`

## 3. Scaffold project

Suggested layout (adapt to language idioms):

```text
README.md
.env.example
src/
  config.ext       # read LENDERLINK_BASE_URL, LENDERLINK_CLIENT_ID, LENDERLINK_CLIENT_SECRET
  auth.ext         # token fetch + in-memory cache using expires_in
  phone.ext        # PH MSISDN normalization
  client.ext       # HTTP wrappers for product POSTs
  main.ext         # CLI or HTTP server entry
examples/
  happy-path.ext
  error-path.ext
```

## 4. Implement auth

- `POST {BASE}/oauth2/token` with JSON `client_credentials`
- Cache `access_token` until ~30–60s before `expires_in`
- Attach `Authorization: Bearer …` to product calls
- On 401: clear cache, re-auth once, retry product once

## 5. Implement product call(s)

- Build JSON body from documented required fields
- Normalize `cellphoneNumber` before send (Full Response / Mega Report)
- Parse `matchFlag` and treat No Hit as success
- Map HTTP errors using `shared/errors.md`

## 6. Examples

- Happy path: token + Full Response (or chosen product) printing `matchFlag` and record count
- Error path: omit a required field and show the 400 envelope

## 7. Definition of done checklist

- [ ] Uses only documented endpoints from OpenAPI / these docs
- [ ] Env-based config; `.env.example` present; no secrets committed
- [ ] OAuth2 `client_credentials` via `/oauth2/token`
- [ ] Token cached; 401 triggers single re-auth + retry
- [ ] Phone normalization applied where the product accepts PH formats
- [ ] README explains install, env, and how to run examples
- [ ] Happy-path and error-path examples run (or are clearly documented)
- [ ] Correct product scope noted in README
- [ ] `matchFlag` Hit / No Hit handled without treating No Hit as an exception
