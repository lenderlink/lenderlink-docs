# Getting started (contributors)

## What you need

| Item | Notes |
|---|---|
| Base URL | Sandbox or production — see [../shared/environments.md](../shared/environments.md) |
| `client_id` / `client_secret` | Issued by LenderLink for your contributor client |
| Scope | `api:msisdn:write` |
| External API mapping | Your client must be mapped to an external API; otherwise upload returns 404 |

## Integration flow

```text
1. POST /oauth2/token  (client_credentials)
2. For each raw MSISDN: normalize → SHA-512 hex
3. POST /api/v1/msisdns/batch  with batches of 1–10000 hashes
4. On 401 → re-auth and retry once
```

## Security

Hash locally. Do not ship production logs that contain raw phone numbers. Demo hashing examples in docs are fine for local development only.

## Next steps

1. [authentication.md](authentication.md)
2. [hashing.md](hashing.md)
3. [msisdn-upload.md](msisdn-upload.md)
