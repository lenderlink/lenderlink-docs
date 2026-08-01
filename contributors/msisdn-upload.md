# MSISDN batch upload

`POST /api/v1/msisdns/batch`

**Scope:** `api:msisdn:write`

## Request body (`Msisdns`)

| Field | Required | Notes |
|---|---|---|
| `msisdns` | yes | Array of strings, min 1, max 10000 |

Each string should be a **SHA-512 hex hash** (preferred). Values are stored lowercased.

```json
{
  "msisdns": [
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
  ]
}
```

See [examples/fixtures/msisdns-batch-request.json](examples/fixtures/msisdns-batch-request.json).

## Success response

```json
{
  "message": "Msisdns uploaded successfully",
  "count": 2
}
```

HTTP 200. See [examples/fixtures/msisdns-batch-response.json](examples/fixtures/msisdns-batch-response.json).

## Limits and behaviour

| Topic | Behaviour |
|---|---|
| Batch size | 1–10000 per request |
| Payload size | Up to ~10MB; timeout ~60s |
| Chunking | For larger sets, split into multiple batches of ≤10000 |
| Idempotency | Re-uploading the same hashes may insert additional rows (batch_number differs). Design uploads as append-oriented unless LenderLink gives you a dedupe process. |
| 404 | `{ "message": "No external API found for the client", "statusCode": 404 }` — client lacks contributor/external-api mapping. Contact LenderLink; do not retry blindly. |

## Headers

```http
Authorization: Bearer <access_token>
Content-Type: application/json
```

## Related

Upload only registers which phones you can answer for. When LenderLink later queries your service about a borrower, return the person/loan object described in [person-data-response.md](person-data-response.md).
