# Mega Report

`POST /api/v1/person/mega-report`

**Scope:** `api:mega-report:read`

Runs one or more products in a single request and returns per-product payloads.

## Request body (`MegaReportPayload`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id (UUID v4 recommended) |
| `cellphoneNumber` | yes | PH mobile; accepts `63…`, `+63…`, `09…`, `9…` |
| `dateOfBirth` | yes | ISO date `YYYY-MM-DD` |
| `firstName` | yes | 2–50 chars |
| `lastName` | yes | 2–50 chars |
| `email` | no | Valid email |
| `idNumber` | no | Identity document number |
| `productIds` | yes | Comma-separated product codes |

### Allowed `productIds`

| Code | Product |
|---|---|
| `FR` | Full Response |
| `PT` | Payment Transactions |
| `CHA` | Credit History Aggregated |
| `TS` | Telco Score |
| `LAC` | Loan Application Check |

Example: `"FR,PT,CHA"`

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

Keys for products that did not Hit may be omitted. Additional keys may appear if new product codes are enabled.

### `response.FR` (Full Response block)

| Field | Type | Description |
|---|---|---|
| `data` | array of loan records | Same `PersonLoanRecord` items as [full-response.md](full-response.md#data--loan--application-record-personloanrecord) |
| `summary` | object \| omitted | Same optional `PersonFullSummary` as Full Response |
| `scores` | object \| omitted | Same optional `PersonScores` as Full Response |

Field-by-field definitions for every loan record, summary, and score field: see [full-response.md](full-response.md#success-response-personfullresponse).

### `response.PT` / `response.CHA`

Contributor-specific object or array — same variability as the standalone [payment-transactions](payment-transactions.md) and [credit-history-aggr](credit-history-aggr.md) products. Envelope product fields above are stable; nested shapes depend on your configured contributors.

### `response.TS` / `response.LAC`

Contributor-specific objects. Map fields from sandbox responses for the contributors assigned to your client.
