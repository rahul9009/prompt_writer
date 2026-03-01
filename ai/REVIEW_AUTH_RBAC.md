#.ai/REVIEW_AUTH_RBAC.md
# Review: Backend Auth+RBAC & Angular Dashboard Integration

## Summary

- **401 vs 403**: Backend uses 401 for missing/invalid token and 403 for insufficient permission; Angular error interceptor maps 401 → logout + login, 403 → /forbidden. Semantics are correct.
- **Token safety**: No token or password logging in app code; AuthService uses in-memory token only (no localStorage).
- **Permission naming**: All permissions follow `entity.action` (role.manage, permission.manage, user.manage, dashboard.read). Seed and routes are consistent.
- **API contract**: CurrentUserResponse (id, email, is_active, permissions) matches Angular CurrentUser; login and /me endpoints align with frontend usage.

---

## Issues by Severity

### High

*None.*

### Medium

1. **Login error display (422)**  
   Backend 422 returns `detail` as an array of validation errors. The login component uses `err.error?.detail ?? 'Login failed'`; when `detail` is an array this can render poorly.  
   **Fix**: Coerce `detail` to a string (e.g. first message or joined messages) in the login component.

### Low

1. **Unused import**  
   `backend/app/services/rbac.py` imports `joinedload` but does not use it.  
   **Fix**: Remove the unused import.

---

## Concrete Fixes (Applied)

### 1. backend/app/services/rbac.py

Remove unused `joinedload` import:

```diff
- from sqlalchemy.orm import Session, joinedload
+ from sqlalchemy.orm import Session
```

### 2. web/src/app/features/auth/login/login.component.ts

Normalize error `detail` (string or array) so 422 validation errors display correctly:

- Treat `err.error?.detail` as `string | Array<{ msg?: string }> | undefined`.
- If array, show first `msg` or joined messages; otherwise show string or fallback to `'Login failed'`.
- Ensures no `[object Object]` when backend returns 422 with `detail: [{ msg, loc, type }]`.
