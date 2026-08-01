# Payment Transactions

`POST /api/v1/person/payment-transactions`

**Scope:** `api:payment-transactions:read`

Returns payment-transaction contributor data for a person.

## Request body (`PersonPaymentTransactionsQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id (UUID v4 recommended) |
| `cellphoneNumber` | yes | Digits form `63` + 10 digits (`^63[0-9]{10}$`) |
| `email` | yes | Valid email |

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "email": "juan@example.com"
}
```

## Success response (`PersonContributorDataResponse`)

| Field | Type | Always present | Description |
|---|---|---|---|
| `requestId` | string | yes | Echo of the request identifier |
| `matchFlag` | string | yes | `Hit` if contributor data was found; otherwise `No Hit` |
| `data` | object \| array | yes | Contributor-specific payment-transaction payload (see below) |

### `data`

`data` is **not** a fixed LenderLink loan schema. It is the payload returned by the payment-transaction contributor(s) configured for your client. It may be:

- a single JSON **object**, or
- an **array** of objects

Nested field names and types are defined by each contributor integration. Treat the envelope (`requestId`, `matchFlag`, `data`) as stable; map nested `data` fields from your sandbox responses for the contributors assigned to your client.

On `No Hit`, `data` is still present but typically empty (`{}` or `[]` depending on contributor behaviour).
