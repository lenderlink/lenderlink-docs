# Full Response

`POST /api/v1/person/full`

**Scope:** `api:full:read`

Returns normalized loan/application records from contributors for a person inquiry.

## Request body (`PersonQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id (UUID v4 recommended) |
| `cellphoneNumber` | yes | PH mobile; accepts `63…`, `+63…`, `09…`, `9…` |
| `dateOfBirth` | yes | ISO date `YYYY-MM-DD`, not in the future |
| `firstName` | yes | 2–50 chars |
| `lastName` | yes | 2–50 chars |
| `email` | no | Valid email |
| `idNumber` | no | Identity document number |

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "dateOfBirth": "1990-01-15",
  "firstName": "Juan",
  "lastName": "Dela Cruz",
  "email": "juan@example.com",
  "idNumber": "A1234567"
}
```

## Success response (`PersonFullResponse`)

| Field | Notes |
|---|---|
| `requestId` | Echo of request |
| `cellphoneNumber` | Echo when applicable |
| `matchFlag` | `Hit` or `No Hit` |
| `data` | Array of loan records (may be empty on No Hit) |
| `summary` | Optional feature summary |
| `scores` | Optional score-model map |

Fixtures:

- [../examples/fixtures/person-full-hit.json](../examples/fixtures/person-full-hit.json)
- [../examples/fixtures/person-full-no-hit.json](../examples/fixtures/person-full-no-hit.json)

Loan record fields include KYC attributes (`kycSurname`, `kycFirstName`, …), loan info (`loanInfoStatusCode`, balances, dates), `contributorId`, and match metadata (`matchedKeys`, `matchedKeyCount`). See OpenAPI model `PersonLoanRecord`.

## Headers

```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

## CRIF XML (optional / advanced)

JSON is the default. Some clients may request CRIF-style XML via `Accept` when configured on the server. Do not implement XML unless the user explicitly requires it; keep JSON as the default path.

## Errors

See [../../shared/errors.md](../../shared/errors.md) and [../examples/fixtures/error-400.json](../examples/fixtures/error-400.json).
