# Getting started (contributors)

## What you need

| Item | Notes |
|---|---|
| Base URL | Sandbox or production for LenderLink APIs — see [../shared/environments.md](../shared/environments.md) |
| `client_id` / `client_secret` | Issued by LenderLink for your contributor client |
| Scope | `api:msisdn:write` for MSISDN upload |
| External API mapping | Your client must be mapped to an external API; otherwise upload returns 404 |
| Your inquiry URL | HTTPS endpoint LenderLink will call; response shape in [person-data-response.md](person-data-response.md) |

## Two jobs of a contributor service

```text
A. Register coverage (to LenderLink)
   1. POST /oauth2/token  (client_credentials)  ← LenderLink auth
   2. Normalize MSISDN → SHA-512 hex
   3. POST /api/v1/msisdns/batch

B. Answer inquiries (your API, called by LenderLink)
   1. Authenticate the caller using YOUR rules
      (Basic, Bearer, API key header, … — see authentication.md)
   2. Receive person lookup (phone, name, DOB, …)
   3. Return Hit/No Hit + loan/application list
      using the fields in person-data-response.md
```

Job B is what clients ultimately see inside Full Response `data` after LenderLink normalizes and merges contributors. Shape your records so that merge is straightforward—same attribute names, same status vocabulary.

## Security

Hash MSISDNs before upload. Do not log raw phone numbers in production. Keep inquiry responses limited to fields you are allowed to share under your LenderLink agreement.

## Next steps

1. [authentication.md](authentication.md)
2. [person-data-response.md](person-data-response.md)
3. [hashing.md](hashing.md)
4. [msisdn-upload.md](msisdn-upload.md)
