# MSISDN hashing

LenderLink matches contributor MSISDNs as **SHA-512 hex digests** of the **digits-only normalized** phone number.

## Algorithm (must match core-api)

1. Normalize to Philippines form `63` + 10 digits (see [../shared/phone-normalization.md](../shared/phone-normalization.md)).
2. Take digits only (strip spaces, `+`, quotes, etc.).
3. Compute SHA-512 over the UTF-8 digits string.
4. Encode as **lowercase hexadecimal** (128 characters).

Pseudo-code:

```text
cleaned = digitsOnly(normalize(msisdn))
hash = hex(sha512(cleaned)).toLowerCase()
```

## Example

| Step | Value |
|---|---|
| Input | `09171230006` |
| Normalized digits | `639171230006` |
| SHA-512 hex | 128-char string (compute in your language; do not hard-code wrong digests) |

Verify locally:

```bash
# After normalizing to 639171230006
printf '%s' '639171230006' | shasum -a 512
```

## Why hash locally

- Preferred upload payload is an array of hashes.
- Avoids sending raw MSISDNs over the wire when your pipeline can hash at the edge.
- Matching systems expect the same SHA-512 of digits-only values.
