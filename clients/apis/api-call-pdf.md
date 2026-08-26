# API Call Detail PDF

`GET /api/v1/hub/requests/api-call-log/{requestId}/pdf`

Downloads the **API Call Detail** report as a PDF for one inquiry. The layout matches the Hub **Requests & Data Processing** Form view (HIT / NO HIT, score, KYC, loans, data summary).

This is a **Hub** API (not the person-product host). `clientId` is taken from the JWT — never from the URL.

**Scope:** `api:customer-admin:write` (same access as the Hub Requests page)

## Hosts

| Environment | Hub base URL |
|---|---|
| Sandbox | `https://sandbox-hub.lenderlink.ph` |
| Production | `https://hub.lenderlink.ph` |

## Path parameter

| Name | Required | Notes |
|---|---|---|
| `requestId` | yes | The id you sent on the original person/product API call. **Any non-empty string** up to 256 characters: UUID, numeric id, nanoid, or other client-generated value. URL-encode reserved characters (`/`, `?`, `#`, spaces, etc.). |

Examples of valid `requestId` values: `550e8400-e29b-41d4-a716-446655440000`, `XkJc2lgFEea`, `12345`.

## Auth

```http
Authorization: Bearer <hub_access_token>
```

Use a **Hub user** Bearer token whose payload includes `clientId` and scope `api:customer-admin:write`. Product-only OAuth2 tokens without that scope receive **403**.

The lookup is always scoped to `clientId` in the JWT. You cannot download another organisation’s call.

## Lookup window

The Hub searches audit rows from the **last 30 calendar days** in Asia/Manila (the same window as the API call log). Older `requestId`s return **404**.

## Success response

| Item | Value |
|---|---|
| HTTP status | `200` |
| `Content-Type` | `application/pdf` |
| `Content-Disposition` | `attachment; filename=api-call-{requestId}.pdf` (unsafe filename characters stripped) |

The body is the PDF bytes.

## Errors

| Status | When |
|---|---|
| 400 | Missing or empty `requestId`, or longer than 256 characters |
| 401 | Missing/invalid token, or token has no `clientId` |
| 403 | Token lacks `api:customer-admin:write` |
| 404 | No matching API call for this JWT `clientId` in the last 30 days |
| 503 | PDF renderer is not configured on the host |
| 500 | PDF generation failed |

JSON error envelope matches [../../shared/errors.md](../../shared/errors.md).

## Example

```bash
HUB=https://hub.lenderlink.ph
REQUEST_ID='XkJc2lgFEea'

curl -sS -L \
  -H "Authorization: Bearer $HUB_TOKEN" \
  -o "api-call-${REQUEST_ID}.pdf" \
  "$HUB/api/v1/hub/requests/api-call-log/${REQUEST_ID}/pdf"
```

If `requestId` contains reserved URL characters:

```bash
ENCODED=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$REQUEST_ID")
curl -sS -L \
  -H "Authorization: Bearer $HUB_TOKEN" \
  -o "api-call.pdf" \
  "$HUB/api/v1/hub/requests/api-call-log/${ENCODED}/pdf"
```

## Related Hub endpoints (same auth and `clientId` scoping)

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/api/v1/hub/requests/api-call-log` | Paginated API call log (optional `requestId` query filter; any string) |
| `GET` | `/api/v1/hub/requests/api-call-log/export` | XLSX export of the filtered log |
| `GET` | `/api/v1/hub/requests/api-call-log/{requestId}/pdf` | This PDF download |

The Hub portal **Download PDF** control on API Call Detail still opens the browser print dialog. This endpoint is the programmatic download.
