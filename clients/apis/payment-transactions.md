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

## Success response

Shape (`PersonContributorDataResponse`):

| Field | Notes |
|---|---|
| `requestId` | Echo |
| `matchFlag` | `Hit` or `No Hit` |
| `data` | Object or array; contributor-specific payload |

Exact `data` fields vary by configured payment-transaction contributors. Treat OpenAPI as the contract envelope; do not invent nested fields beyond what you observe in sandbox responses for your client.
