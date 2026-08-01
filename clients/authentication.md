# Authentication (clients)

Server-to-server integrations should use **OAuth2 client credentials**.

## Primary (recommended): `POST /oauth2/token`

Content-Type: `application/json` (also accepts `application/x-www-form-urlencoded`).

```json
{
  "grant_type": "client_credentials",
  "client_id": "YOUR_CLIENT_ID",
  "client_secret": "YOUR_CLIENT_SECRET"
}
```

### Success response

```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

See [examples/fixtures/token-response.json](examples/fixtures/token-response.json).

### Using the token

```http
Authorization: Bearer <access_token>
```

## Alternate: `POST /oauth/token`

Legacy OAuth endpoint with the same grant types. Prefer `/oauth2/token` for new integrations. Both are documented in OpenAPI.

## Token lifetime

- Use `expires_in` (seconds) to schedule refresh.
- There is no refresh-token flow for `client_credentials`. When expired (or on `401`), call `/oauth2/token` again.
- Cache the token in memory; avoid requesting a new token for every product call.

## Password grant

`grant_type=password` exists for interactive user login and is **not** recommended for generated machine services. Do not use password grant unless the user explicitly requires Hub/UI-style login.

## Logout

- `POST /oauth2/logout` (and legacy `POST /oauth/logout`) — optional for long-lived processes; typically unused for short-lived batch jobs.
