# Credit History Aggregated

`POST /api/v1/person/credit-history-aggr`

**Scope:** `api:credit-history-aggregated:read`

Returns aggregated credit-history contributor data.

## Request body (`PersonCreditHistoryAggregatedQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id (UUID v4 recommended) |
| `cellphoneNumber` | yes | Digits form `63` + 10 digits (`^63[0-9]{10}$`) |
| `email` | no | Valid email |
| `idNumber` | no | Identity document number |

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "email": "juan@example.com",
  "idNumber": "A1234567"
}
```

## Success response

Same envelope as payment transactions (`PersonContributorDataResponse`):

| Field | Notes |
|---|---|
| `requestId` | Echo |
| `matchFlag` | `Hit` or `No Hit` |
| `data` | Object or array; contributor-specific |

Use sandbox responses for your provisioned contributors to map nested fields.
