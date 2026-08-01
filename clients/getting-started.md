# Getting started (clients)

## What you need

| Item | Notes |
|---|---|
| Base URL | Sandbox or production — see [../shared/environments.md](../shared/environments.md) |
| `client_id` / `client_secret` | Issued by LenderLink (not self-serve) |
| Product scopes | Assigned to your client — see [scopes-and-products.md](scopes-and-products.md) |

## Integration flow

```text
1. POST /oauth2/token  (client_credentials)
2. Cache access_token until expires_in
3. POST /api/v1/person/<product>  with Authorization: Bearer <token>
4. On 401 → step 1 again, then retry once
```

## Recommended first product

Start with [Full Response](apis/full-response.md) (`POST /api/v1/person/full`) if your client has `api:full:read`.

## Next steps

1. [authentication.md](authentication.md)
2. [scopes-and-products.md](scopes-and-products.md)
3. [examples/curl.md](examples/curl.md)
