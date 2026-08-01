# Authentication (contributors)

There are **two different directions** of authentication. Do not mix them up.

| Direction | Who calls whom | Who chooses the scheme |
|---|---|---|
| A — Upload / LenderLink APIs | Your service → LenderLink | Fixed: OAuth2 `client_credentials` |
| B — Inquiry API | LenderLink → your service | **You** choose, based on your security rules |

---

## A. Calling LenderLink (MSISDN upload)

Same pattern as clients. Use this only for LenderLink endpoints such as token and `POST /api/v1/msisdns/batch`.

### Recommended: `POST /oauth2/token`

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

Use on LenderLink product calls:

```http
Authorization: Bearer <access_token>
```

Your JWT must include scope **`api:msisdn:write`**. Missing scope → HTTP 403.

Legacy `POST /oauth/token` also works; prefer `/oauth2/token` for new integrations.

Details shared with clients: [../clients/authentication.md](../clients/authentication.md).

---

## B. Protecting your inquiry API (LenderLink calls you)

Your person-data endpoint is hosted by you. **Authentication is not prescribed by LenderLink.** Implement whatever your security policy requires, and share the exact scheme and credentials with LenderLink during onboarding so they can configure request headers for your external API.

Common options:

### HTTP Basic

```http
Authorization: Basic <base64(username:password)>
```

### Bearer token

```http
Authorization: Bearer <token>
```

The token may be a static shared secret, a JWT you issue, or another format you define. Agree validation and rotation with LenderLink.

### API key header

A custom header whose name and value you define, for example:

```http
X-API-Key: <shared-secret>
```

or

```http
X-LenderLink-Api-Key: <shared-secret>
```

Header name is yours to choose; tell LenderLink the exact name and value (or how to obtain a short-lived value).

### Other

mTLS, signed query params, or combinations of the above are fine if LenderLink can be configured to send them. Document your rules clearly for the onboarding team.

### What to tell LenderLink

When you hand over your inquiry URL, include:

- Auth type (Basic, Bearer, API key header, …)
- Header name(s) and how credentials are encoded
- Whether credentials are static or refreshed, and how
- Test credentials for sandbox

Your **response body** must still follow [person-data-response.md](person-data-response.md) regardless of which auth scheme you pick.
