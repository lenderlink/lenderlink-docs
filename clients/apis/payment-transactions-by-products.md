# Payment Transactions by Products (PT1–PT4)

`POST /api/v1/person/payment-transactions/by-products`

**Scope:** `api:payment-transactions:read`

Returns payment transaction data for one or more standalone Payment Transaction products in a single request. Each product is requested, returned and processed independently.

This endpoint is separate from [Payment Transactions](payment-transactions.md) (product code `PT`). The request and response formats are different.

## Products

| Product | Product code | Response location | Fields |
|---|---|---|---|
| Payment Transactions 1 | `PT1` | `data.PT1` | [PT1 and PT2](#datapt1--datapt2) |
| Payment Transactions 2 | `PT2` | `data.PT2` | [PT1 and PT2](#datapt1--datapt2) |
| Payment Transactions 3 | `PT3` | `data.PT3` | [PT3](#datapt3) |
| Payment Transactions 4 | `PT4` | `data.PT4` | [PT4](#datapt4) |

You can only request products that are enabled for your client. Contact LenderLink to enable a product. See [scopes-and-products.md](../scopes-and-products.md#product-access-pt1pt4).

## Request body (`PersonPaymentTransactionsByProductsQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id for this inquiry. Any non-empty string (UUID, number, nanoid, or other client id). UUID v4 is recommended. **Not** echoed in the response; keep your own reference. |
| `cellphoneNumber` | yes | Digits form `63` + 10 digits (`^63[0-9]{10}$`). Other formats are rejected with 400 |
| `email` | no | Valid email |
| `productIds` | yes | JSON **array** of product codes, e.g. `["PT3", "PT4"]`. At least one; each code at most once; case-sensitive |

```json
{
  "requestId": "8f14e45f-ceea-467a-9c1e-0a1b2c3d4e5f",
  "cellphoneNumber": "639000000001",
  "email": "borrower@example.com",
  "productIds": ["PT3", "PT4"]
}
```

## Success response (`PersonPaymentTransactionsByProductsResponse`)

| Field | Type | Always present | Description |
|---|---|---|---|
| `productIds` | string[] | yes | Product codes that returned a Hit, in the order they were requested |
| `matchFlag` | string | yes | `Hit` if at least one product returned a Hit; otherwise `No Hit` |
| `data` | object | yes | One entry per product that returned a Hit, keyed by product code. Each product has its own structure (see below) |

- Products that do not return a Hit are omitted from both `productIds` and `data`.
- An omitted product means no Hit was returned; it does **not** confirm that the borrower has no transactions. A product is also omitted when its data source cannot be reached or returns an unusable response.
- The response does **not** include `requestId`.
- Property names are returned in camelCase. Values and nesting are returned as provided by the data source.
- PT1/PT2, PT3 and PT4 have different structures. Process each product independently.

Fixtures:

- [../examples/fixtures/payment-transactions-by-products-hit.json](../examples/fixtures/payment-transactions-by-products-hit.json) (all four products)
- [../examples/fixtures/payment-transactions-by-products-no-hit.json](../examples/fixtures/payment-transactions-by-products-no-hit.json)

### Match

Both requested products returned a Hit (payloads shortened):

```json
{
  "productIds": ["PT3", "PT4"],
  "matchFlag": "Hit",
  "data": {
    "PT3": {
      "statusCode": 200,
      "message": "Request Successful",
      "trackingId": "55555555-5555-4555-8555-555555555555",
      "data": [
        {
          "transactionCategory": "Topups",
          "mobileNumber": "639000000001",
          "amount": 500,
          "dateIn": "2026-08-14T09:35:40",
          "status": 2
        }
      ]
    },
    "PT4": {
      "tenant": "lenderlink",
      "withResults": true,
      "results": [
        {
          "txnId": "TXN_EXAMPLE_0001",
          "amount": "250.00",
          "sector": "EMI",
          "storeId": "STR_EXAMPLE_01",
          "merchantName": "Example Wallet",
          "transactionDate": "2026-08-14"
        }
      ]
    }
  }
}
```

### Partial match

`PT3` and `PT4` were requested; only `PT4` returned a Hit:

```json
{
  "productIds": ["PT4"],
  "matchFlag": "Hit",
  "data": {
    "PT4": {
      "tenant": "lenderlink",
      "withResults": true,
      "results": [
        {
          "txnId": "TXN_EXAMPLE_0001",
          "amount": "250.00",
          "sector": "EMI",
          "storeId": "STR_EXAMPLE_01",
          "merchantName": "Example Wallet",
          "transactionDate": "2026-08-14"
        }
      ]
    }
  }
}
```

### No match

No product returned a Hit (still HTTP 200). This response is also returned when none of the requested data sources could provide a usable response.

```json
{
  "productIds": [],
  "matchFlag": "No Hit",
  "data": {}
}
```

## `data.PT1` / `data.PT2`

PT1 and PT2 use the same structure. Full example: [hit fixture](../examples/fixtures/payment-transactions-by-products-hit.json).

| Field | Type | Description |
|---|---|---|
| `startDate` | string | Date and time of the lookup, ISO 8601 with time-zone offset. The period covered runs back from this date to `endDate`, and the age buckets below are counted from this date |
| `endDate` | string | Earliest date covered by the period (`rangeMonths` before `startDate`), ISO 8601 with time-zone offset |
| `rangeMonths` | integer | Length of the period in months |
| `transactionCount` | integer | Number of successful transactions within the period |
| `minAmount` | number | Smallest transaction amount within the period |
| `maxAmount` | number | Largest transaction amount within the period |
| `aveAmount` | number | Average transaction amount within the period |
| `sumAmount` | number | Total transaction amount within the period |
| `stdDev` | number | Population standard deviation of the amounts |
| `refDates` | string[] \| null | Dates (`YYYY-MM-DD`) when the transactions occurred |
| `refDateDetails` | array of Ref Date Records \| null | Number and total amount of transactions on each date |
| `categories` | string[] \| null | Categories of the merchants involved in the transactions |
| `procIds` | string[] \| null | Payment processors used for the transactions |
| `within1to30Days` | array of Sub-details Records \| null | Transactions 1 to 30 days before `startDate`, by category |
| `within31to60Days` | array of Sub-details Records \| null | Transactions 31 to 60 days before `startDate`, by category |
| `beyond61Days` | array of Sub-details Records \| null | Transactions more than 60 days before `startDate`, by category |

Array fields can be empty (`[]`) or `null` when no transactions fall into that group. PT1 and PT2 do not return `matchKey`.

Ref Date Record:

| Field | Type | Description |
|---|---|---|
| `refDate` | string | Transaction date (`YYYY-MM-DD`) |
| `count` | integer | Number of transactions on that date |
| `total` | number | Total amount of the transactions on that date |

Sub-details Record:

| Field | Type | Description |
|---|---|---|
| `category` | string | Industry or category of the merchant |
| `transactionCount` | integer | Number of successful transactions in the category within the time bucket |
| `minAmount` | number | Smallest transaction amount in the category within the time bucket |
| `maxAmount` | number | Largest transaction amount in the category within the time bucket |
| `sumAmount` | number | Total amount in the category within the time bucket |
| `stdDev` | number | Population standard deviation of the amounts |

## `data.PT3`

| Field | Type | Description |
|---|---|---|
| `statusCode` | integer | Status reported by the data source. It is **not** the HTTP status of the response |
| `data` | array of Transaction Records | The borrower's transactions; can contain many records |
| `message` | string | Message reported by the data source |
| `trackingId` | string | Tracking reference reported by the data source |

Transaction Record:

| Field | Type | Description |
|---|---|---|
| `id` | integer \| string | Transaction record identifier |
| `transactionCategory` | string | Transaction category, e.g. `Topups` |
| `guid` | string | Unique transaction identifier |
| `customerId` | integer \| string | Customer identifier at the data source |
| `terminalId` | string | Terminal where the transaction was made |
| `referenceNumber` | string | Transaction reference number |
| `officialReceiptNumber` | string \| null | Official receipt number, when issued |
| `traceNo` | string | Trace number |
| `mobileNumber` | string | Mobile number linked to the transaction |
| `identifier` | string | Additional identifier; can be empty |
| `billerTag` | string \| null | Biller or service code |
| `amount` | number \| string | Transaction amount |
| `tranType` | string | Transaction type code |
| `dateIn` | string | Date and time the transaction was received (`YYYY-MM-DDThh:mm:ss`) |
| `status` | integer \| string | Transaction status code |
| `statusMsg` | any JSON value | Status details for the transaction. The structure varies from one transaction to another; it is usually an object with nested fields or a text message, but any JSON value is possible. Read it defensively |
| `timestamp` | string | Date and time the transaction was recorded (`YYYY-MM-DDThh:mm:ss`) |
| `terminalCity` | string \| null | City of the terminal |
| `terminalProvince` | string \| null | Province of the terminal |
| `terminalRegion` | string \| null | Region of the terminal |

## `data.PT4`

| Field | Type | Description |
|---|---|---|
| `tenant` | string | Data source tenant |
| `withResults` | boolean | `true` when transactions were found |
| `results` | array of Result Records | The borrower's transactions |
| `metadata` | object (Metadata Record) | Summary of how the results were prepared |

Result Record:

| Field | Type | Description |
|---|---|---|
| `txnId` | string | Transaction identifier |
| `amount` | string | Transaction amount as a decimal string, e.g. `"250.00"` |
| `transactionDate` | string | Transaction date (`YYYY-MM-DD`) |
| `sector` | string | Merchant sector |
| `storeId` | string | Store identifier |
| `merchantName` | string | Merchant name |

Metadata Record:

| Field | Type | Description |
|---|---|---|
| `totalBeforeDedup` | integer | Number of transactions found before duplicates were removed |
| `totalAfterDedup` | integer | Number of transactions returned after duplicates were removed |
| `duplicatesRemoved` | integer | Number of duplicate transactions removed |
| `queryMethod` | string | Lookup method used by the data source |
| `anonymizationEnabled` | boolean | Whether identifiers in the results are anonymised |

## Headers

```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

## Errors

| Status | `message` | When |
|---|---|---|
| 400 | Validation message, e.g. `"productIds" must contain at least 1 items` | Invalid body: missing required field, wrong phone format, or `productIds` empty or with duplicates. `details` lists the field errors |
| 400 | `PT_PRODUCT_UNSUPPORTED` | A product code is not recognised. Codes are case-sensitive |
| 401 | `Unauthorized` | Missing, invalid or expired token |
| 403 | `Insufficient scope` | Token lacks `api:payment-transactions:read` |
| 403 | `PT_PRODUCT_NOT_ENTITLED` | One or more requested products are not enabled for your client. `details` lists them. No products are returned |
| 500 | `An internal server error occurred` | Unexpected error. Retry later or contact LenderLink |

```json
{
  "statusCode": 403,
  "error": "Forbidden",
  "message": "PT_PRODUCT_NOT_ENTITLED",
  "details": [
    { "productId": "PT2" }
  ]
}
```

JSON error envelope matches [../../shared/errors.md](../../shared/errors.md).

## Via Mega Report

PT1–PT4 can also be requested through [Mega Report](mega-report.md#standalone-payment-transaction-products-pt1pt4) together with other products. The product payloads are the same; the request and response wrappers differ:

| | This endpoint | Mega Report |
|---|---|---|
| `productIds` in request | Array: `["PT3", "PT4"]` | Comma-separated string: `"PT3,PT4"` |
| Person fields | `cellphoneNumber`, optional `email` | Full person details (name, date of birth, phone) |
| Product location | `data.<code>` | `response.<code>` |
| `requestId` returned | No | Yes |
| `matchFlag` | Yes | No |
