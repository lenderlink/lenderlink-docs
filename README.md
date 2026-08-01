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
