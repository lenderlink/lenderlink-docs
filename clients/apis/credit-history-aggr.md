# Credit History Aggregated

`POST /api/v1/person/credit-history-aggr`

**Scope:** `api:credit-history-aggregated:read`

Returns aggregated credit-history contributor data.

## Request body (`PersonCreditHistoryAggregatedQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id for this inquiry. Any non-empty string (UUID, number, nanoid, or other client id). UUID v4 is recommended. Echoed in the response; used to download the [API Call Detail PDF](api-call-pdf.md). |
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

## Success response (`PersonContributorDataResponse`)

| Field | Type | Always present | Description |
|---|---|---|---|
| `requestId` | string | yes | Echo of the request identifier |
| `matchFlag` | string | yes | `Hit` if contributor data was found; otherwise `No Hit` |
| `data` | object \| array | yes | Contributor-specific credit-history payload (see below) |

### `data`

`data` is **not** a fixed LenderLink loan schema. It is the payload returned by the credit-history-aggregated contributor(s) configured for your client. It may be:

- a single JSON **object**, or
- an **array** of objects

Nested field names and types are defined by each contributor integration. Treat the envelope (`requestId`, `matchFlag`, `data`) as stable; map nested `data` fields from your sandbox responses for the contributors assigned to your client.

On `No Hit`, `data` is still present but typically empty (`{}` or `[]` depending on contributor behaviour).
