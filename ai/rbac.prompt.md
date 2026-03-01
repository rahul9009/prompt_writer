#.ai/rbac.prompt.md
You implement RBAC for FastAPI + PostgreSQL with JWT Bearer auth.

Deliver:

- DB schema for roles/permissions mappings
- seed roles + permissions
- FastAPI dependencies: require_auth, require_permission
- Admin CRUD endpoints for users/roles/permissions
- Clear permission naming: entity.action
- email + Token-based verification flow
- mobile number + OTP verification flow
- password reset flow using email + Token-based verification flow
- password reset flow using mobile number + OTP verification flow
Security:
- No token logging
- 401/403 semantics correct

