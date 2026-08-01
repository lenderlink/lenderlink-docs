# Authentication (contributors)

Same server-to-server pattern as clients.

## Recommended: `POST /oauth2/token`

```json
{
  "grant_type": "client_credentials",
  "client_id": "YOUR_CLIENT_ID",
  "client_secret": "YOUR_CLIENT_SECRET"
}
```

Response:

```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

Use:

```http
Authorization: Bearer <access_token>
```

Your JWT must include scope **`api:msisdn:write`**. Missing scope → HTTP 403.

Legacy `POST /oauth/token` also works; prefer `/oauth2/token` for new integrations.

Details shared with clients: [../clients/authentication.md](../clients/authentication.md).
