# Environments

## Base URLs

| Environment | API base URL |
|---|---|
| Sandbox | `https://sandbox-app.lenderlink.ph` |
| Production | `https://v2-app.lenderlink.ph` |

All paths in these docs are relative to the base URL (for example `POST {BASE}/oauth2/token`).

## Recommended client configuration (env)

```bash
LENDERLINK_BASE_URL=https://sandbox-app.lenderlink.ph
LENDERLINK_CLIENT_ID=...
LENDERLINK_CLIENT_SECRET=...
```

## Timeouts

- Prefer connect timeout ≈ 5s and overall request timeout ≥ 30s for person product calls (upstream contributors may be slow).
- MSISDN batch upload may need up to 60s for large batches.

## TLS

Use HTTPS only. Do not disable certificate verification in production.

## Public OpenAPI

| Resource | Path |
|---|---|
| Swagger UI | `/documentation/public` (HTTP basic auth; credentials provided by LenderLink) |
| OpenAPI JSON | `/swagger-public.json` |

A committed snapshot lives in [openapi/swagger-public.json](openapi/swagger-public.json).
