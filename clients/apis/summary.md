# Summary (lite)

`POST /api/v1/person/summary`

**Scope:** `api:lite:read`

Returns a compact internal summary for a phone number.

## Request body (`PersonLiteQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id (UUID v4 recommended) |
| `cellphoneNumber` | yes | Digits form `63` + 10 digits (`^63[0-9]{10}$`) |

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006"
}
```

## Success response (`PersonLiteSummaryResponse`)

The HTTP body may be:

- a **JSON object** with the fields below, or
- `null` when no summary data is available

When the body is an object:

| Field | Type | Always present | Description |
|---|---|---|---|
| `numApp` | integer | yes | Number of applications |
| `numAcc` | integer | yes | Number of accounts |
| `wasDpd30Ever` | integer | yes | Ever 30+ days past due (`0` or `1`) |
| `wasDpd90Ever` | integer | yes | Ever 90+ days past due (`0` or `1`) |
| `wasDpd30Last3Months` | integer | yes | 30+ DPD in last 3 months (`0` or `1`) |
| `wasDpd90Last3Months` | integer | yes | 90+ DPD in last 3 months (`0` or `1`) |
| `wasDpd30LastYear` | integer | yes | 30+ DPD in last year (`0` or `1`) |
| `wasDpd90LastYear` | integer | yes | 90+ DPD in last year (`0` or `1`) |

Unlike Full Response, this product does **not** wrap results in `matchFlag` / `data`. A `null` body means no summary; a populated object means summary values are available.
