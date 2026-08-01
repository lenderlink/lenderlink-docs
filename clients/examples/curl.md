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

## 4. Credit History Aggregated

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

## 5. Mega Report

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

## 6. Summary

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
