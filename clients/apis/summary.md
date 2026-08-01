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

May be `null` when no data is available. When present:

| Field | Notes |
|---|---|
| `numApp` | Number of applications |
| `numAcc` | Number of accounts |
| `wasDpd30Ever` | Ever 30+ DPD (0/1) |
| `wasDpd90Ever` | Ever 90+ DPD (0/1) |
| `wasDpd30Last3Months` | 30+ DPD last 3 months (0/1) |
| `wasDpd90Last3Months` | 90+ DPD last 3 months (0/1) |
| `wasDpd30LastYear` | 30+ DPD last year (0/1) |
| `wasDpd90LastYear` | 90+ DPD last year (0/1) |
