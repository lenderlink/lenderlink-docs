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

| Field | Notes |
|---|---|
| `requestId` | Echo |
| `productIds` | Array of product codes that returned a Hit |
| `response` | Object keyed by product code (`FR`, `PT`, `CHA`, `TS`, `LAC`) |

`response.FR` (when present) contains `data` (loan records) and optional `summary` / `scores`. Other keys are contributor-specific objects/arrays.
