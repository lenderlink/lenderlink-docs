# Full Response

`POST /api/v1/person/full`

**Scope:** `api:full:read`

Returns normalized loan/application records from contributors for a person inquiry.

## Request body (`PersonQuery`)

| Field | Required | Notes |
|---|---|---|
| `requestId` | yes | Unique id for this inquiry. Any non-empty string (UUID, number, nanoid, or other client id). UUID v4 is recommended. Echoed in the response; used to download the [API Call Detail PDF](api-call-pdf.md). |
| `cellphoneNumber` | yes | PH mobile; accepts `63…`, `+63…`, `09…`, `9…` |
| `dateOfBirth` | yes | ISO date `YYYY-MM-DD`, not in the future |
| `firstName` | yes | 2–50 chars |
| `lastName` | yes | 2–50 chars |
| `email` | no | Valid email |
| `idNumber` | no | Identity document number |

```json
{
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "cellphoneNumber": "639171230006",
  "dateOfBirth": "1990-01-15",
  "firstName": "Juan",
  "lastName": "Dela Cruz",
  "email": "juan@example.com",
  "idNumber": "A1234567"
}
```

## Success response (`PersonFullResponse`)

Top-level fields:

| Field | Type | Always present | Description |
|---|---|---|---|
| `requestId` | string | yes | Echo of the request identifier |
| `cellphoneNumber` | string | no | Requested cellphone number when applicable |
| `matchFlag` | string | yes | `Hit` if any contributor records were found; otherwise `No Hit` |
| `data` | array of `PersonLoanRecord` | yes | Normalized loan/application records; empty array on No Hit |
| `summary` | object (`PersonFullSummary`) | no | Feature aggregates; only when enabled for the client (`can_use_full_response_summary`) |
| `scores` | object (`PersonScores`) | no | Score-model outputs; only when enabled for the client (`can_use_score`) |

Fixtures:

- [../examples/fixtures/person-full-hit.json](../examples/fixtures/person-full-hit.json)
- [../examples/fixtures/person-full-no-hit.json](../examples/fixtures/person-full-no-hit.json)

### `data[]` — loan / application record (`PersonLoanRecord`)

Each element is one contributor loan or application. Fields may be `null` when the contributor did not supply them.

#### Identity / KYC

| Field | Type | Description |
|---|---|---|
| `recordID` | string \| null | Contributor loan/application record identifier |
| `kycSurname` | string \| null | Surname / last name |
| `kycFirstName` | string \| null | First name |
| `kycMiddleName` | string \| null | Middle name |
| `kycDateOfBirth` | string \| null | Date of birth (`YYYY-MM-DD`) |
| `kycIdNumber` | string \| null | Identity document number |
| `kycIdType` | any \| null | Identity document type code (contributor-defined) |
| `kycMobileNumber` | string \| null | Mobile number associated with the loan |
| `kycEmailAddress` | string \| null | Email address |
| `kycAddress` | string \| null | Address |

#### Loan information

| Field | Type | Description |
|---|---|---|
| `loanInfoLoanType` | any \| null | Loan type code (contributor-defined) |
| `loanInfoApplicationDate` | string \| null | Application date (`YYYY-MM-DD`) |
| `loanInfoOpenDate` | string \| null | Loan open / disbursement date (`YYYY-MM-DD`) |
| `loanInfoLoanTerm` | number \| null | Loan term |
| `loanInfoOpenBalance` | number \| null | Original / open balance |
| `loanInfoOutstandingBalance` | number \| null | Outstanding balance |
| `loanInfoNextDueDate` | string \| null | Next due date (`YYYY-MM-DD`) |
| `loanInfoLastPaymentAmount` | number \| null | Last payment amount |
| `loanInfoLastPaymentDate` | string \| null | Last payment date (`YYYY-MM-DD`) |
| `loanInfoStatusCode` | string \| null | Loan status: `Active`, `Delayed`, `Collection`, `Written off`, `Closed`, `Rejected`, `Incomplete`, `Not Disbursed` |
| `loanInfoInstallmentAmount` | number \| null | Installment amount |
| `loanInfoOverdueAmount` | number \| null | Overdue amount |
| `loanInfoRepaymentFrequency` | any \| null | Repayment frequency code (contributor-defined) |
| `loanInfoRepaymentHistory` | string \| null | Encoded repayment history string |
| `loanInfoRepaymentFullHistory` | array \| null | Detailed repayment history entries (see below) |
| `loanInfoCloseDate` | string \| null | Loan close date (`YYYY-MM-DD`) |
| `loanInfoLenderType` | string \| null | Lender type |

#### Match metadata

| Field | Type | Description |
|---|---|---|
| `contributorId` | string \| null | Contributor public identifier |
| `matchedKeys` | string[] \| null | Request fields that matched this record (e.g. `cellphoneNumber`, `firstName`) |
| `matchedKeyCount` | integer \| null | Number of matched keys |

#### `loanInfoRepaymentFullHistory[]` (`PersonLoanRepaymentHistoryItem`)

| Field | Type | Description |
|---|---|---|
| `dueDate` | string \| null | Installment due date (`YYYY-MM-DD`) |
| `paymentDate` | string \| null | Payment date (`YYYY-MM-DD`) |
| `paymentAmount` | number \| null | Payment amount |

### `summary` — feature summary (`PersonFullSummary`)

Present only when enabled for your client. Values are numeric aggregates / flags derived from `data`. Additional model features may appear beyond this list.

#### Counts and balances

| Field | Description |
|---|---|
| `numApp` | Number of applications |
| `numAcc` | Number of accounts / disbursed loans |
| `minOpenBalance` | Minimum open balance across loans |
| `maxOpenBalance` | Maximum open balance across loans |
| `sumOpenBalance` | Sum of open balances |
| `avgOpenBalance` | Average open balance |
| `minOutstanding` | Minimum outstanding balance |
| `maxOutstanding` | Maximum outstanding balance |
| `sumOutstanding` | Sum of outstanding balances |
| `avgOutstanding` | Average outstanding balance |
| `minLastPayment` | Minimum last payment amount |
| `maxLastPayment` | Maximum last payment amount |
| `sumLastPayment` | Sum of last payment amounts |
| `avgLastPayment` | Average last payment amount |
| `minInstallment` | Minimum installment amount |
| `maxInstallment` | Maximum installment amount |
| `sumInstallment` | Sum of installment amounts |
| `avgInstallment` | Average installment amount |
| `minOverdue` | Minimum overdue amount |
| `maxOverdue` | Maximum overdue amount |
| `sumOverdue` | Sum of overdue amounts |
| `avgOverdue` | Average overdue amount |
| `minLoanTerm` | Minimum loan term |
| `maxLoanTerm` | Maximum loan term |
| `avgLoanTerm` | Average loan term |
| `maxUtilizationRate` | Maximum utilization rate |

#### Status counts

| Field | Description |
|---|---|
| `numActiveLoan` | Count of Active loans |
| `numClosedLoans` | Count of Closed loans |
| `numDelayedLoans` | Count of Delayed loans |
| `numRejectedLoans` | Count of Rejected loans |
| `numCollectionLoans` | Count of Collection loans |
| `numIncompleteLoans` | Count of Incomplete loans |
| `numNotDisbLoans` | Count of Not Disbursed loans |
| `numWrittenoffLoans` | Count of Written off loans |

#### Delinquency and history flags (typically `0` / `1`)

| Field | Description |
|---|---|
| `noHistPerf` | No historical performance flag |
| `wasDpd30Ever` | Ever 30+ days past due |
| `wasDpd90Ever` | Ever 90+ days past due |
| `wasDpd30Last3Months` | 30+ DPD in last 3 months |
| `wasDpd90Last3Months` | 90+ DPD in last 3 months |
| `wasDpd30LastYear` | 30+ DPD in last year |
| `wasDpd90LastYear` | 90+ DPD in last year |

#### Application / product mix

| Field | Description |
|---|---|
| `avgApplDays` | Average days between applications |
| `daysSinceLastApplication` | Days since last application |
| `numDistLoanType` | Number of distinct loan types |
| `numPaydayLoans` | Count of payday loans |
| `numPosLoans` | Count of POS loans |
| `numCashLoans` | Count of cash loans |
| `numRevLoans` | Count of revolving loans |
| `numCCLoans` | Count of credit-card loans |
| `numAutoLoans` | Count of auto loans |
| `numMotoLoans` | Count of motorcycle loans |
| `numHomeLoans` | Count of home loans |
| `age` | Derived applicant age |

#### Ratios and risk flags

| Field | Description |
|---|---|
| `ratioDisbAppl` | Disbursed-to-application ratio |
| `ratioOutstandingOpenbalance` | Outstanding-to-open-balance ratio |
| `ratioOverdueInstallment` | Overdue-to-installment ratio |
| `avgUtilizationRate` | Average utilization rate |
| `paymentToOutstandingRatio` | Payment-to-outstanding ratio |
| `avgPaymentToInstallmentRatio` | Average payment-to-installment ratio |
| `highOutstandingFlag` | High outstanding flag (0/1) |
| `veryHighOutstandingFlag` | Very high outstanding flag (0/1) |
| `overdueFlag` | Overdue flag (0/1) |
| `highOverdueFlag` | High overdue flag (0/1) |
| `avgOpenBalancePerLoan` | Average open balance per loan |
| `avgOutstandingPerLoan` | Average outstanding per loan |
| `openRange` | Open-balance range (max − min) |
| `outstandingRange` | Outstanding-balance range (max − min) |
| `installmentRange` | Installment range (max − min) |
| `balanceVolatilityProxy` | Open-balance volatility proxy |
| `outstandingVolatilityProxy` | Outstanding volatility proxy |
| `installmentVolatilityProxy` | Installment volatility proxy |
| `outstandingToOpenTrendProxy` | Outstanding-to-open trend proxy |
| `overdueTrendProxy` | Overdue trend proxy |
| `loanTermTrendProxy` | Loan-term trend proxy |

#### Frequency and rates

| Field | Description |
|---|---|
| `isFrequentApplicant` | Frequent applicant flag (0/1) |
| `isMediumFreqApplicant` | Medium-frequency applicant flag (0/1) |
| `isInfrequentApplicant` | Infrequent applicant flag (0/1) |
| `applicationFrequencyTrend` | Application frequency trend |
| `closedRate` | Closed loan rate |
| `activeRate` | Active loan rate |
| `delayedRate` | Delayed loan rate |
| `collectionRate` | Collection loan rate |
| `writtenoffRate` | Written-off loan rate |
| `rejectRate` | Rejected loan rate |
| `notDisbRate` | Not-disbursed loan rate |
| `incompleteRate` | Incomplete loan rate |
| `hasBadHistory` | Bad history flag (0/1) |
| `hasCleanClosedHistory` | Clean closed history flag (0/1) |
| `badToGoodRatio` | Bad-to-good history ratio |

#### Diversity and recency

| Field | Description |
|---|---|
| `numDistContr` | Number of distinct contributors |
| `shareBiggestContr` | Share of records from the largest contributor |
| `numDistIdNum` | Number of distinct ID numbers |
| `numDistIdType` | Number of distinct ID types |
| `numDistPhones` | Number of distinct phone numbers |
| `numDistEmail` | Number of distinct emails |
| `numDistNames` | Number of distinct names |
| `daysSinceLastReject` | Days since last rejection |
| `numRecordsLast10Days` | Records in last 10 days |
| `numRecordsLast30Days` | Records in last 30 days |
| `numRecordsLast60Days` | Records in last 60 days |
| `numRecordsLast90Days` | Records in last 90 days |
| `numRecordsLast180Days` | Records in last 180 days |
| `maxRecWeek` | Maximum records in a week |
| `minDaysApp` | Minimum days between applications |
| `maxDaysApp` | Maximum days between applications |
| `numReqSameDay` | Number of requests for this person on the same day |

### `scores` — score models (`PersonScores`)

Object keyed by score type. Common keys: `CS1`, `CS2.1`, `CS2.2`, `CS2.3`. Additional keys may appear when new models are enabled.

Each score entry (`PersonScoreResult`):

| Field | Type | Description |
|---|---|---|
| `score` | number \| null | Model score value |
| `band` | number \| null | Score band (sentinel such as `-997` when unavailable) |

## Headers

```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

## Errors

See [../../shared/errors.md](../../shared/errors.md) and [../examples/fixtures/error-400.json](../examples/fixtures/error-400.json).
