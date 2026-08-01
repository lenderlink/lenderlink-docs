# Contributor curl examples

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

## 2. Hash a normalized MSISDN (demo)

```bash
# Demo only — do not log raw MSISDNs in production pipelines
printf '%s' '639171230006' | shasum -a 512 | awk '{print $1}'
```

## 3. Upload a batch

```bash
HASH=$(printf '%s' '639171230006' | shasum -a 512 | awk '{print $1}')

curl -sS -X POST "$BASE/api/v1/msisdns/batch" \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d "{\"msisdns\": [\"$HASH\"]}"
```

Sandbox: `BASE=https://sandbox-app.lenderlink.ph`  
Production: `BASE=https://v2-app.lenderlink.ph`
