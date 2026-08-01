# Public OpenAPI snapshot

Machine-readable contract for public client and contributor endpoints.

| File | Description |
|---|---|
| [swagger-public.json](swagger-public.json) | Snapshot of core-api `GET /swagger-public.json` |

## Refresh

Export from a running core-api (or sandbox/production) that has public docs enabled:

```bash
# Sandbox example (basic auth credentials are issued by LenderLink)
curl -u 'SWAGGER_USER:SWAGGER_PASSWORD' \
  'https://sandbox-app.lenderlink.ph/swagger-public.json' \
  -o shared/openapi/swagger-public.json
```

Local core-api:

```bash
curl -u 'swagger:YOUR_LOCAL_PASSWORD' \
  'http://localhost:3000/swagger-public.json' \
  -o shared/openapi/swagger-public.json
```

Then commit the updated JSON so coding agents and humans share the same contract.

## Source of truth

Prefer the live `/swagger-public.json` for the environment you integrate against. This committed file is for offline LLM generation and docs review.
