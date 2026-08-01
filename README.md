# LenderLink Integration Docs

Integration documentation for **clients** (API consumers) and **contributors** (data providers).

| Audience | Path | Purpose |
|---|---|---|
| Clients | [clients/](clients/) | Authenticate and call person / credit product APIs |
| Contributors | [contributors/](contributors/) | Upload hashed MSISDNs for contributor matching |
| Shared | [shared/](shared/) | Environments, phone rules, errors, OpenAPI snapshot |

## For coding LLMs / agents

Start here:

1. [llms.txt](llms.txt) — discovery index
2. Audience pack: [clients/AGENTS.md](clients/AGENTS.md) or [contributors/AGENTS.md](contributors/AGENTS.md)
3. Machine contract: [shared/openapi/swagger-public.json](shared/openapi/swagger-public.json)

## Credentials

`client_id` / `client_secret` (and scopes) are issued by LenderLink. They are not self-serve from these docs.

## CI/CD (Bitbucket → GitHub)

Source of truth is Bitbucket (`lenderlink/lenderlink-docs`). On every push to `main`, the pipeline syncs the same commit to [github.com/lenderlink/lenderlink-docs](https://github.com/lenderlink/lenderlink-docs.git).

### Bitbucket setup

1. Repository settings → **Pipelines** → enable Pipelines.
2. Repository settings → **Repository variables** → add secured variable:
   - Name: `GITHUB_TOKEN`
   - Value: GitHub personal access token (classic: `repo` scope) or fine-grained token with **Contents: Read and write** on `lenderlink/lenderlink-docs`
3. Optional variables:
   - `GITHUB_REPO` (default `lenderlink/lenderlink-docs`)
   - `GITHUB_BRANCH` (default `main`)

A custom pipeline named **sync-to-github** can re-run the sync manually from Bitbucket.
