# ADR 005: Remove embedded observability and Ollama services

**Date:** 2026-06-24
**Status:** Accepted
**Deciders:** Gireg Roussel

---

## Context

The sandbox originally shipped with an embedded observability stack (OTel Collector, Prometheus, Grafana) and an Ollama service for local LLM inference. These were defined as full services in `docker-compose.yml` and removed in a prior PR.

After that removal, residual artifacts remained: environment variables in `docker-compose.yml` (`OLLAMA_HOST`, `OTEL_*`, `CLAUDE_CODE_ENABLE_TELEMETRY`), orphaned config files under `observability/`, and README/CONTRIBUTING references to services that no longer ran.

The original removal was motivated by:

1. **Nobody was using the observability data** — the dashboards went unchecked and provided no actionable insight for a single-user sandbox.
2. **Codeburn replaced the need** — token spend analytics (the primary use case for the OTel/Grafana stack) are now handled by Codeburn reading Claude Code session data directly.
3. **Simplify the project** — focus the sandbox on its core value (AI coding tools in an isolated container) rather than maintaining ancillary infrastructure.

---

## Options considered

### Option A: Clean up residual artifacts

Remove the leftover environment variables, config files, and documentation references that pointed to the already-removed services.

| | |
|---|---|
| Pros | Eliminates confusion; aligns codebase with actual state; fewer Trivy findings to manage |
| Cons | None significant — the services are already gone |
| Complexity | Trivial |

### Option B: Restore services as opt-in compose profiles

Re-add observability and Ollama as Docker Compose profiles (`--profile observability`, `--profile ollama`) so they're available but don't start by default.

| | |
|---|---|
| Pros | Available for users who want them; documents the intended setup |
| Cons | Maintenance burden returns; Codeburn already covers the primary use case; adds cognitive overhead |
| Complexity | Low |

---

## Decision

Option A adopted. Residual artifacts cleaned up:

- `observability/` directory deleted (otel-collector-config.yaml, prometheus.yml)
- `OLLAMA_HOST`, `CLAUDE_CODE_ENABLE_TELEMETRY`, and all `OTEL_*` env vars removed from `docker-compose.yml`
- README and CONTRIBUTING references to Ollama, Grafana, Prometheus, and OTel removed
- ADR-002 and ADR-003 left unchanged as historical records of the original design intent

Observability can be re-introduced later as a compose profile (Option B) if demand arises.

---

## References

- [ADR 002: Sandbox isolation with worktrees](002-sandbox-isolation-worktree.md) (references the original shared-services design)
- [ADR 003: Sandbox interaction modes](003-sandbox-interaction-modes.md)
