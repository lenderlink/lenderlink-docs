# Person data your service should return

When LenderLink asks your contributor service about a borrower, respond with **one JSON object** that answers three questions:

1. Which inquiry is this? (echo the request id if you received one)
2. Did you find matching credit activity? (`Hit` / `No Hit`)
3. What loans or applications do you hold for that person?

That object should feel familiar to anyone who has seen a client Full Response: same idea (inquiry + hit flag + list of loans), and each loan uses the **same attribute names** lenders already consume. You do **not** need to invent client-only extras such as `summary` or `scores`—LenderLink builds those from the loan list when a client is entitled to them.

## Top-level result

| Field | Type | Description |
|---|---|---|
| `requestId` | string | Echo of the inquiry id from LenderLink, when provided |
| `cellphoneNumber` | string | no | Mobile number the inquiry was about (normalized `63` + 10 digits when you include it) |
| `matchFlag` | string | `Hit` if you are returning at least one loan/application; `No Hit` if you have nothing to share |
| `data` | array | Loan and application records (see below). Use `[]` when `matchFlag` is `No Hit` |

Example — found activity:

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "matchFlag": "Hit",
  "data": [
    {
      "recordID": "REC-1001",
      "kycSurname": "Dela Cruz",
      "kycFirstName": "Juan",
      "kycMiddleName": null,
      "kycDateOfBirth": "1990-01-15",
      "kycIdNumber": "A1234567",
      "kycIdType": null,
      "kycMobileNumber": "639171230006",
      "kycEmailAddress": "juan@example.com",
      "kycAddress": null,
      "loanInfoLoanType": 1,
      "loanInfoApplicationDate": "2024-03-01",
      "loanInfoOpenDate": "2024-03-05",
      "loanInfoLoanTerm": 30,
      "loanInfoOpenBalance": 5000,
      "loanInfoOutstandingBalance": 2500,
      "loanInfoNextDueDate": "2024-04-05",
      "loanInfoLastPaymentAmount": 500,
      "loanInfoLastPaymentDate": "2024-03-20",
      "loanInfoStatusCode": "Active",
      "loanInfoInstallmentAmount": 500,
      "loanInfoOverdueAmount": 0,
      "loanInfoRepaymentFrequency": 1,
      "loanInfoRepaymentHistory": null,
      "loanInfoRepaymentFullHistory": null,
      "loanInfoCloseDate": null,
      "loanInfoLenderType": null,
      "contributorId": null,
      "matchedKeys": ["cellphoneNumber", "firstName", "lastName"],
      "matchedKeyCount": 3
    }
  ]
}
```

Example — nothing found:

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440099",
  "cellphoneNumber": "639999999999",
  "matchFlag": "No Hit",
  "data": []
}
```

Fixtures: [examples/fixtures/person-data-hit.json](examples/fixtures/person-data-hit.json), [examples/fixtures/person-data-no-hit.json](examples/fixtures/person-data-no-hit.json).

> Some existing integrations still return a bare **array** of loan records. Prefer the object above for new services. If you must return only an array, use the same loan fields; LenderLink treats a non-empty array as a hit.

## Each item in `data` (one loan or application)

Omit unknown values as `null`. Dates use `YYYY-MM-DD`.

### Who the borrower is (KYC)

| Field | Type | Description |
|---|---|---|
| `recordID` | string \| null | Your internal id for this loan or application |
| `kycSurname` | string \| null | Last name |
| `kycFirstName` | string \| null | First name |
| `kycMiddleName` | string \| null | Middle name |
| `kycDateOfBirth` | string \| null | Date of birth |
| `kycIdNumber` | string \| null | Government / ID document number |
| `kycIdType` | any \| null | Document type code you use internally |
| `kycMobileNumber` | string \| null | Mobile on the account |
| `kycEmailAddress` | string \| null | Email on the account |
| `kycAddress` | string \| null | Address |

### Loan details

| Field | Type | Description |
|---|---|---|
| `loanInfoLoanType` | any \| null | Product / loan type code |
| `loanInfoApplicationDate` | string \| null | When the customer applied |
| `loanInfoOpenDate` | string \| null | When the loan was opened or disbursed |
| `loanInfoLoanTerm` | number \| null | Term length |
| `loanInfoOpenBalance` | number \| null | Original / open principal |
| `loanInfoOutstandingBalance` | number \| null | Amount still owed |
| `loanInfoNextDueDate` | string \| null | Next installment due date |
| `loanInfoLastPaymentAmount` | number \| null | Last payment amount |
| `loanInfoLastPaymentDate` | string \| null | Last payment date |
| `loanInfoStatusCode` | string \| null | One of: `Active`, `Delayed`, `Collection`, `Written off`, `Closed`, `Rejected`, `Incomplete`, `Not Disbursed` |
| `loanInfoInstallmentAmount` | number \| null | Regular installment |
| `loanInfoOverdueAmount` | number \| null | Amount currently overdue |
| `loanInfoRepaymentFrequency` | any \| null | How often repayments are due |
| `loanInfoRepaymentHistory` | string \| null | Compact encoded payment history, if you use one |
| `loanInfoRepaymentFullHistory` | array \| null | Itemized repayments (see below) |
| `loanInfoCloseDate` | string \| null | When the loan closed |
| `loanInfoLenderType` | string \| null | Lender category, if applicable |

### How the match was made

| Field | Type | Description |
|---|---|---|
| `contributorId` | string \| null | Leave null unless LenderLink asked you to stamp a public id |
| `matchedKeys` | string[] \| null | Which inquiry fields matched (e.g. `cellphoneNumber`, `firstName`) |
| `matchedKeyCount` | integer \| null | Count of `matchedKeys` |

### `loanInfoRepaymentFullHistory[]`

| Field | Type | Description |
|---|---|---|
| `dueDate` | string \| null | Installment due date |
| `paymentDate` | string \| null | When payment was made |
| `paymentAmount` | number \| null | Amount paid |

## Inquiry inputs you typically receive

LenderLink calls the URL and method configured for your external API. Common person fields (names may vary per template):

| Concept | Typical values |
|---|---|
| Request id | UUID |
| Mobile | Digits-only `63` + 10 digits |
| Name | First and last name |
| Date of birth | `YYYY-MM-DD` |
| Email / ID number | Optional |

Exact query/body mapping is agreed when LenderLink onboards your endpoint. Your **response** should still follow this document.

### Authentication on this call

How LenderLink authenticates **to you** is your choice (Basic, Bearer, API key header, or another scheme you require). See [authentication.md](authentication.md#b-protecting-your-inquiry-api-lenderlink-calls-you). Share the concrete headers and secrets with LenderLink at onboarding.

## How this fits with MSISDN upload

| Step | Purpose |
|---|---|
| [Hash + upload MSISDNs](msisdn-upload.md) | Tell LenderLink which phones you can answer for (pre-filter) |
| This person-data response | Answer a concrete borrower inquiry with loan records |

Both are part of a complete contributor integration.
