#AGENTS.md
# AI AGENTS (FastAPI + Angular + Flutter | JWT Bearer + PostgreSQL)

## 🧠 Orchestrator (Default)
- Splits tasks into backend/web/mobile deliverables
- Keeps API contract consistent across clients
- Ensures minimal, safe changes

## 🔧 Backend Agent (FastAPI + PostgreSQL)
Focus:
- REST API design + OpenAPI correctness
- JWT Bearer auth, RBAC (if required)
- PostgreSQL schema design, migrations, indexing
- Performance: avoid N+1, pagination, caching where needed
- Observability: structured logs, metrics-ready patterns
Standards:
- Pydantic schemas everywhere
- `Depends` for auth and DB session
- 409 on unique conflicts
- No token/secret logging

## 🎨 Web Frontend Agent (Angular)
Focus:
- Auth interceptor adds Bearer token
- Global error handling for 401/403
- RxJS correctness (no leaks, no nested subs)
- Reactive forms + validators
Standards:
- No token in localStorage unless explicitly required
- Strong typing, no `any` unless justified
- Loading/error states for async flows
- Permission-based route access
- Scaffold rules followed
- Responsive design
- Angular Material UI

## 📱 Mobile Agent (Flutter)
Focus:
- Secure token storage (Keychain/Keystore)
- Robust networking + timeouts
- Consistent state management (Riverpod/Bloc)
Standards:
- Keep widgets lean; use repositories
- Typed models and safe JSON parsing
- Never log tokens
- Flutter Material UI
- Light Dark Theme (system default)

## 🔍 Review Agent (Quality + Security)
Checks:
- Auth correctness (401/403 behavior, token handling)
- Injection risks, validation gaps
- Postgres migrations + indexes
- Client/server contract mismatch
- Perf pitfalls (N+1, heavy rebuilds, RxJS leaks)
Output:
- Summary (2–4 bullets)
- Issues by severity: High/Medium/Low
- Fix suggestions with file references