# Errors

## Error envelope

Validation and many API failures return JSON shaped like:

```json
{
  "statusCode": 400,
  "error": "Bad Request",
  "message": "human-readable summary",
  "details": []
}
```

`details` is optional and often present for Joi validation failures (array of field errors).

## Common status codes

| Code | Meaning |
|---|---|
| 400 | Invalid request / validation failure |
| 401 | Missing or invalid Bearer token |
| 403 | Authenticated but missing required scope |
| 404 | Resource or client mapping not found (e.g. MSISDN upload without contributor mapping) |
| 406 | Not Acceptable |
| 429 | Rate limit exceeded (client-specific quotas) |
| 500 | Internal / upstream failure |

## Auth failures

On `401`, obtain a new access token (`client_credentials`) and retry once. Do not invent refresh-token flows unless LenderLink documents them for your grant type.

## Rate limits

Limits are configured per client (per window / hour / day / etc.). Treat `429` as temporary: back off and retry with jitter. Exact quotas are provided when credentials are issued.
