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
| 403 | Authenticated but missing required scope, or a requested Payment Transaction product (`PT1`–`PT4`) is not enabled for your client |
| 404 | Resource or client mapping not found (e.g. MSISDN upload without contributor mapping) |
| 406 | Not Acceptable |
| 429 | Rate limit exceeded (client-specific quotas) |
| 500 | Internal / upstream failure |

## Product error messages

Some product APIs return a fixed code in `message`:

| Status | `message` | Returned by | Meaning |
|---|---|---|---|
| 400 | `PT_PRODUCT_UNSUPPORTED` | [Payment Transactions by Products](../clients/apis/payment-transactions-by-products.md) | A product code is not recognised (codes are case-sensitive) |
| 403 | `PT_PRODUCT_NOT_ENTITLED` | Payment Transactions by Products, [Mega Report](../clients/apis/mega-report.md) | One or more requested `PT1`–`PT4` products are not enabled for your client. `details` lists them as `{ "productId": "PT2" }`. No data is returned |
| 400 | `MEGA_PRODUCT_UNSUPPORTED` | Mega Report | A product code is not supported |
| 400 | `MEGA_PAYMENT_TRANSACTION_MODE_CONFLICT` | Mega Report | Legacy `PT` was combined with `PT1`–`PT4` |

## Auth failures

On `401`, obtain a new access token (`client_credentials`) and retry once. Do not invent refresh-token flows unless LenderLink documents them for your grant type.

## Rate limits

Limits are configured per client (per window / hour / day / etc.). Treat `429` as temporary: back off and retry with jitter. Exact quotas are provided when credentials are issued.
