#ROADMAP.md
# ROADMAP

## Phase 0 — Core Security Foundation (RBAC)
- ✅ JWT bearer auth baseline (done/verify)
- ✅ DB schema: users, roles, permissions, mappings
- ✅ Seed: default roles (admin, manager, viewer)
- [ ] Permission evaluation service (DB + cache-ready)
- [ ] FastAPI dependencies: require_auth, require_permission
- [ ] Admin endpoints: manage users/roles/perms

## Phase 1 — Dashboards
### Web (Angular)
- ✅ Auth pages + guards + interceptors
- ✅ Shell layout (sidebar/topbar)
- [ ] Permission-based navigation
- ✅  Admin screens: Users, Roles, Permissions
- [ ] Dashboard home + metrics placeholders

### Mobile (Flutter)
- [ ] Auth pages + secure storage + session manager
- [ ] App shell (bottom nav)
- [ ] Permission-based navigation
- [ ] Profile + logout
- [ ] Dashboard home + placeholders

## Phase 2 — Entities (Iterative)
For each entity:
- [ ] DB migration + constraints + indexes
- [ ] Permissions: entity.get/gets/post/put/patch/delete
- [ ] FastAPI CRUD + pagination + tests
- [ ] Angular list/detail/forms + route guards
- [ ] Flutter list/detail/forms + state management
- [ ] Review checklist pass
