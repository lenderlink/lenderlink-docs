# Contributor integration

Build a **contributor service** that:

1. Registers hashed MSISDNs with LenderLink (so inquiries can be pre-filtered to you)
2. Answers borrower inquiries with a person/loan result LenderLink can merge for clients

## Start here

1. [getting-started.md](getting-started.md)
2. [authentication.md](authentication.md)
3. [person-data-response.md](person-data-response.md) — what your inquiry API should return
4. [hashing.md](hashing.md)
5. [msisdn-upload.md](msisdn-upload.md)
6. [examples/curl.md](examples/curl.md)

## For coding agents

Read [AGENTS.md](AGENTS.md), then follow [recipes/generate-contributor-uploader.md](recipes/generate-contributor-uploader.md).

Machine contract for LenderLink upload/auth: [../shared/openapi/swagger-public.json](../shared/openapi/swagger-public.json)  
Person-data shape for your own API: [person-data-response.md](person-data-response.md)
