# Philippines phone normalization

LenderLink stores and matches mobile numbers as **digits only** in the form:

```text
63 + 10 digits
```

Example canonical value: `639171230006`

## Accepted input forms

Before hashing or sending as `cellphoneNumber`, normalize as follows (same rules as core-api):

| Input example | Normalized |
|---|---|
| `639171230006` | `639171230006` |
| `+63 917 123 0006` | `639171230006` |
| `09171230006` | `639171230006` |
| `9171230006` | `639171230006` |

Algorithm:

1. Trim whitespace and strip non-digits.
2. If value matches `^63[0-9]{10}$` → use as-is.
3. Else if value matches `^09[0-9]{9}$` → replace leading `0` with `63`.
4. Else if value matches `^9[0-9]{9}$` → prefix `63`.
5. Otherwise → invalid.

## For contributors (hashing)

Hash the **normalized digits-only** value with SHA-512 (hex, 128 characters). See [../contributors/hashing.md](../contributors/hashing.md).
