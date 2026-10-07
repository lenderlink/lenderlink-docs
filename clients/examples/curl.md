# Client curl examples

Replace `BASE`, `CLIENT_ID`, `CLIENT_SECRET`, and `TOKEN` as needed.

## 1. Get token

```bash
curl -sS -X POST "$BASE/oauth2/token" \
  -H 'Content-Type: application/json' \
  -d "{
    \"grant_type\": \"client_credentials\",
    \"client_id\": \"$CLIENT_ID\",
    \"client_secret\": \"$CLIENT_SECRET\"
  }"
```

## 2. Full Response

```bash
curl -sS -X POST "$BASE/api/v1/person/full" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440000",
    "cellphoneNumber": "639171230006",
    "dateOfBirth": "1990-01-15",
    "firstName": "Juan",
    "lastName": "Dela Cruz",
    "email": "juan@example.com"
  }'
```

## 3. Payment Transactions

```bash
curl -sS -X POST "$BASE/api/v1/person/payment-transactions" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440001",
    "cellphoneNumber": "639171230006",
    "email": "juan@example.com"
  }'
```

## 4. Payment Transactions by Products (PT1–PT4)

```bash
curl -sS -X POST "$BASE/api/v1/person/payment-transactions/by-products" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440005",
    "cellphoneNumber": "639171230006",
    "email": "juan@example.com",
    "productIds": ["PT3", "PT4"]
  }'
```

`productIds` is a JSON array here. Only products enabled for your client can be requested.

## 5. Credit History Aggregated

```bash
curl -sS -X POST "$BASE/api/v1/person/credit-history-aggr" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440002",
    "cellphoneNumber": "639171230006",
    "email": "juan@example.com",
    "idNumber": "A1234567"
  }'
```

## 6. Mega Report

```bash
curl -sS -X POST "$BASE/api/v1/person/mega-report" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440003",
    "cellphoneNumber": "639171230006",
    "dateOfBirth": "1990-01-15",
    "firstName": "Juan",
    "lastName": "Dela Cruz",
    "productIds": "FR,PT"
  }'
```

For the standalone Payment Transaction products, send them in the same comma-separated string, e.g. `"productIds": "FR,PT3,PT4"`. Do not combine `PT` with `PT1`–`PT4`.

## 7. Summary

```bash
curl -sS -X POST "$BASE/api/v1/person/summary" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "requestId": "550e8400-e29b-41d4-a716-446655440004",
    "cellphoneNumber": "639171230006"
  }'
```

Sandbox: `BASE=https://sandbox-app.lenderlink.ph`  
Production: `BASE=https://v2-app.lenderlink.ph`

## 8. API Call Detail PDF (Hub)

Uses the **Hub** host. Auth is a Hub user token (`api:customer-admin:write`) **or** a Core `client_credentials` token with `api:full:read` or `api:mega-report:read`. `requestId` is any string from the original inquiry (UUID, number, nanoid, etc.).

```bash
HUB=https://hub.lenderlink.ph
REQUEST_ID='XkJc2lgFEea'

curl -sS -L \
  -H "Authorization: Bearer $TOKEN" \
  -o "api-call-${REQUEST_ID}.pdf" \
  "$HUB/api/v1/hub/requests/api-call-log/${REQUEST_ID}/pdf"
```

Sandbox Hub: `HUB=https://sandbox-hub.lenderlink.ph`  
Production Hub: `HUB=https://hub.lenderlink.ph`

See [apis/api-call-pdf.md](../apis/api-call-pdf.md).
