# Scopes and products

JWT scopes are assigned when LenderLink provisions your client. Calling a product without the required scope returns **403**.

| Product | Method + path | Required scope |
|---|---|---|
| Full Response | `POST /api/v1/person/full` | `api:full:read` |
| Payment Transactions (legacy `PT`) | `POST /api/v1/person/payment-transactions` | `api:payment-transactions:read` |
| Payment Transactions by Products (`PT1`–`PT4`) | `POST /api/v1/person/payment-transactions/by-products` | `api:payment-transactions:read` |
| Credit History Aggregated | `POST /api/v1/person/credit-history-aggr` | `api:credit-history-aggregated:read` |
| Mega Report | `POST /api/v1/person/mega-report` | `api:mega-report:read` |
| Summary (lite) | `POST /api/v1/person/summary` | `api:lite:read` |

## Hit / No Hit

Most person products return `matchFlag`:

| Value | Meaning |
|---|---|
| `Hit` | At least one contributor returned matching data |
| `No Hit` | No matching contributor data (still HTTP 200) |

## Product access (PT1–PT4)

The standalone Payment Transaction products `PT1`, `PT2`, `PT3` and `PT4` are enabled per client, in addition to the scope. With `api:payment-transactions:read` but without a requested product enabled, the whole request returns **403** `PT_PRODUCT_NOT_ENTITLED` and `details` lists the products. This applies to [Payment Transactions by Products](apis/payment-transactions-by-products.md) and to `PT1`–`PT4` in [Mega Report](apis/mega-report.md). Contact LenderLink to enable a product.

In Mega Report, `PT1`–`PT4` also require `api:payment-transactions:read` on the token; without it they are silently omitted from the response.

## Optional Full Response features

When enabled on your client configuration:

- `summary` — feature aggregates (`can_use_full_response_summary`)
- `scores` — score models such as CS1 / CS2.x (`can_use_score`)

Absence of these fields is normal when the flags are off.

## Hub APIs

| Product | Method + path | Required scope | Host |
|---|---|---|---|
| API Call Detail PDF | `GET /api/v1/hub/requests/api-call-log/{requestId}/pdf` | `api:customer-admin:write` **or** `api:mega-report:read` **or** `api:full:read` | Hub (see [environments.md](../shared/environments.md)) |

See [apis/api-call-pdf.md](apis/api-call-pdf.md). `requestId` is any string you sent on the original inquiry (UUID, number, nanoid, etc.).

## Rate limits

Quotas are per client. Expect HTTP `429` when exceeded; back off and retry. Exact limits are provided with your credentials.
