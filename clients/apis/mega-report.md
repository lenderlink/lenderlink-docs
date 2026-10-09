# Mega Report

`POST /api/v1/person/mega-report`

**Scope:** `api:mega-report:read`

Runs one or more products in a single request and returns per-product payloads.

## Request body (`MegaReportPayload`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id for this inquiry. Any non-empty string (UUID, number, nanoid, or other client id). UUID v4 is recommended. Echoed in the response; used to download the [API Call Detail PDF](api-call-pdf.md). |
| `cellphoneNumber` | yes | PH mobile; accepts `63…`, `+63…`, `09…`, `9…` |
| `dateOfBirth` | yes | ISO date `YYYY-MM-DD` |
| `firstName` | yes | 2–50 chars |
| `lastName` | yes | 2–50 chars |
| `email` | no | Valid email |
| `idNumber` | no | Identity document number |
| `productIds` | yes | Comma-separated product codes (a string, not an array) |

### Allowed `productIds`

| Code | Product |
|---|---|
| `FR` | Full Response |
| `PT` | Payment Transactions (legacy) |
| `CHA` | Credit History Aggregated |
| `TS` | Telco Score |
| `LAC` | Loan Application Check |
| `PT1` | Payment Transactions 1 |
| `PT2` | Payment Transactions 2 |
| `PT3` | Payment Transactions 3 |
| `PT4` | Payment Transactions 4 |

Example: `"FR,PT,CHA"` or `"FR,PT3,PT4"`

Legacy `PT` and the standalone codes `PT1`–`PT4` cannot be combined in one request (400 `MEGA_PAYMENT_TRANSACTION_MODE_CONFLICT`). See [Standalone Payment Transaction products](#standalone-payment-transaction-products-pt1pt4).

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "dateOfBirth": "1990-01-15",
  "firstName": "Juan",
  "lastName": "Dela Cruz",
  "email": "juan@example.com",
  "productIds": "FR,PT"
}
```

## Success response (`MegaReportResponse`)

| Field | Type | Always present | Description |
|---|---|---|---|
| `requestId` | string | yes | Echo of the request identifier |
| `productIds` | string[] | yes | Product codes that returned a Hit (subset of requested codes, e.g. `FR`, `PT`) |
| `response` | object | yes | Per-product payloads keyed by product code (see below) |

### `response` object keys

| Key | Present when | Description |
|---|---|---|
| `FR` | Full Response product ran and returned data | Full Response product payload |
| `PT` | Payment Transactions product ran and returned data | Payment Transactions product payload |
| `CHA` | Credit History Aggregated product ran and returned data | Credit History Aggregated product payload |
| `TS` | Telco Score product ran and returned data | Telco Score product payload (contributor-specific object) |
| `LAC` | Loan Application Check product ran and returned data | Loan Application Check product payload (contributor-specific object) |
| `PT1`–`PT4` | Standalone Payment Transaction product ran and returned a Hit | Product payload; see [Standalone Payment Transaction products](#standalone-payment-transaction-products-pt1pt4) |

Keys for products that did not Hit may be omitted. Additional keys may appear if new product codes are enabled.

### `response.FR` (Full Response block)

| Field | Type | Description |
|---|---|---|
| `data` | array of loan records | Same `PersonLoanRecord` items as [full-response.md](full-response.md#data--loan--application-record-personloanrecord) |
| `summary` | object \| omitted | Same optional `PersonFullSummary` as Full Response |
| `scores` | object \| omitted | Same optional `PersonScores` as Full Response |

Field-by-field definitions for every loan record, summary, and score field: see [full-response.md](full-response.md#success-response-personfullresponse).

### `response.PT` / `response.CHA`

Contributor-specific object or array — same variability as the single-product [payment-transactions](payment-transactions.md) and [credit-history-aggr](credit-history-aggr.md) products. Envelope product fields above are stable; nested shapes depend on your configured contributors.

### `response.TS` / `response.LAC`

Contributor-specific objects. Map fields from sandbox responses for the contributors assigned to your client.

## Standalone Payment Transaction products (PT1–PT4)

`PT1`, `PT2`, `PT3` and `PT4` can be requested with any other Mega Report product except legacy `PT`. Each product is selected and returned independently. Payloads are the same as in [Payment Transactions by Products](payment-transactions-by-products.md); see that page for every field.

| Code | Response location | Fields |
|---|---|---|
| `PT1` | `response.PT1` | [PT1 and PT2](payment-transactions-by-products.md#datapt1--datapt2) |
| `PT2` | `response.PT2` | [PT1 and PT2](payment-transactions-by-products.md#datapt1--datapt2) |
| `PT3` | `response.PT3` | [PT3](payment-transactions-by-products.md#datapt3) |
| `PT4` | `response.PT4` | [PT4](payment-transactions-by-products.md#datapt4) |

Keep sending `productIds` as a comma-separated string, e.g. `"PT3,PT4"` or `"FR,PT3,PT4"`.

- `productIds` in the response contains only products that returned a Hit.
- Each Hit is returned under its product code in `response`.
- Products that do not return a Hit are omitted from both `productIds` and `response`. An omitted product means no Hit was returned; it does **not** confirm that the borrower has no transactions.
- A requested product is silently omitted when your access token lacks the required product scope (`api:payment-transactions:read`). If the token has that scope but the product is not enabled for your client, the entire request returns HTTP 403 `PT_PRODUCT_NOT_ENTITLED`.
- There is no top-level `matchFlag`.
- Property names are returned in camelCase. Each product has its own structure.

**Legacy and standalone Payment Transactions cannot be combined.** Use either `PT` or `PT1`–`PT4`, not both. Valid: `PT`, `PT3`, `PT3,PT4`, `FR,PT3,PT4`. Invalid: `PT,PT3`, `PT,PT1,PT2`.

Match example (`"PT3,PT4"`, payloads shortened):

```json
{
  "requestId": "8f14e45f-ceea-467a-9c1e-0a1b2c3d4e5f",
  "productIds": ["PT3", "PT4"],
  "response": {
    "PT3": {
      "statusCode": 200,
      "message": "Request Successful",
      "trackingId": "55555555-5555-4555-8555-555555555555",
      "data": [
        {
          "transactionCategory": "Topups",
          "mobileNumber": "639000000001",
          "amount": 500,
          "dateIn": "2026-08-14T09:35:40",
          "status": 2
        }
      ]
    },
    "PT4": {
      "withResults": true,
      "results": [
        {
          "txnId": "TXN_EXAMPLE_0001",
          "amount": "250.00",
          "sector": "EMI",
          "storeId": "STR_EXAMPLE_01",
          "merchantName": "Example Wallet",
          "transactionDate": "2026-08-14"
        }
      ]
    }
  }
}
```

No match example:

```json
{
  "requestId": "8f14e45f-ceea-467a-9c1e-0a1b2c3d4e5f",
  "productIds": [],
  "response": {}
}
```

## Errors

| Status | `message` | When |
|---|---|---|
| 400 | `MEGA_PRODUCT_UNSUPPORTED` | A product code is not supported |
| 400 | `MEGA_PAYMENT_TRANSACTION_MODE_CONFLICT` | Legacy `PT` was combined with `PT1`, `PT2`, `PT3` or `PT4` |
| 403 | `PT_PRODUCT_NOT_ENTITLED` | A requested standalone Payment Transaction product is not enabled for your client. `details` lists the products. No data is returned for the request |

```json
{
  "statusCode": 400,
  "error": "Bad Request",
  "message": "MEGA_PAYMENT_TRANSACTION_MODE_CONFLICT"
}
```

```json
{
  "statusCode": 403,
  "error": "Forbidden",
  "message": "PT_PRODUCT_NOT_ENTITLED",
  "details": [
    { "productId": "PT4" }
  ]
}
```

Other statuses and the JSON error envelope: [../../shared/errors.md](../../shared/errors.md).
