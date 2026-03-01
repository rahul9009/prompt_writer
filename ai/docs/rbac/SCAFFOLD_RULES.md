#.ai/docs/rbac/SCAFFOLD_RULES.md
# SCAFFOLD_RULES.md (Optimized - Production Ready)

---

# 🧱 1. Core Principles

## 🔐 Deny by Default
- Access तभी मिले जब permission explicitly assign की गई हो।
- कोई implicit logic नहीं (जैसे `gets ⇒ full access`) ❌  
---
## 🎯 Single Source of Truth
- सभी permissions एक central registry (Dictionary/Enum) में define हों। 
- यही Registry:
  - DB seed करेगा  
  - Backend authorization enforce करेगी।
  - Frontend UI/UX control करेगी।
---
## 🛡 Backend is Authority
- Frontend सिर्फ UX (User Experience) control है (Hide/Show UI)।
- Final security decision backend करेगा।
- यदि API call करने के लिए permission नहीं है, तो Server `403 Forbidden` error देगा।
---
# 🧠 2. Permission Model
## 📌 Format
`entity.action` (e.g., `users.post`)
---
## 📦 Naming Rules
| Layer | Format | Example |
|------|--------|---------|
| Docs/Concepts | PascalCase | UserRole |
| DB Tables/Cols | snake_case | user_roles |
| API Routes | kebab-case | /api/user-roles |
| Permissions | plural entity | users.gets |
---
## ⚙️ Standard Actions
### 🔹 Core CRUD
| Action | Meaning |
|--------|--------|
| get | View single entity details |
| gets | View list of entities (pagination/table) |
| post | Create new entity |
| put | Full update of an entity |
| patch | Partial update of an entity |
| delete | Remove/Soft-delete entity |

---
### 🔹 Junction Actions
| Action | Meaning |
|--------|--------|
| assign | Link two entities (e.g., user to role) |
| remove | Unlink two entities |
| export | Export list to CSV/PDF |
| import | Import from file |
| approve | Approve a status/workflow |

---
### 🔹 System Permissions
| Permission | Meaning |
|-----------|--------|
| dashboard.read | Access main dashboard |
| dashboard.manage| Manage dashboard widgets |

---

## 🚫 Rules
- `read` का इस्तेमाल CRUD entities के लिए न करें (`get`/`gets` use करें)। ❌
- Optional actions (export, print) तभी use करें जब business logic में सख्त जरूरत हो।

---

# 🧭 3. Permission Semantics (CRITICAL)

## ✅ Rule 1: Module Visibility (ENTRY POINT)
👉 **अगर `entity.gets` नहीं है:**
- ❌ Menu item नहीं दिखेगा।
- ❌ Tab नहीं दिखेगा।
- ❌ Dashboard card नहीं दिखेगा।
- ❌ Frontend Route access नहीं होगा।
- ❌ CRUD form access नहीं होगा।

---

## ✅ Rule 2: Action Control
`entity.gets ≠ full access`
हर action के लिए explicit permission जरूरी है। List दिखने का मतलब यह नहीं कि User Create या Delete भी कर सकता है।
---

# 🧱 4. Permission Registry (Single Source)

## Example

```python
# permission_registry.py
PERMISSION_REGISTRY = {
    "users": ["get", "gets", "post", "put", "patch", "delete"],
    "roles": ["get", "gets", "post", "put", "patch", "delete"],
    "permissions": ["get", "gets"], # Usually read-only in UI
}

JUNCTION_PERMISSIONS = {
    "user_roles": ["assign", "remove"],
    "role_permissions": ["assign", "remove"],
}

SPECIAL_PERMISSIONS = ["dashboard.read", "settings.manage"]
```
---

# 🧩 5. Role Design (Policy)

| Role | Allowed Permissions |
|------|--------------------|
| Viewer | `*.gets`, `*.get`, `dashboard.read` |
| Manager | `viewer` + `*.post`, `*.put`, `*.patch` (optional: `assign/remove`) |
| Admin | `manager` + `*.delete` |
| Super Admin | ALL permissions (Wildcard `*.` for all actions) |

---
# ⚙️ 6. Backend (FastAPI)

## 🔐 Authorization
```python
@router.get("/", dependencies=[Depends(require_permission("users.get"))])
@router.get("/", dependencies=[Depends(require_permission("users.gets"))])
@router.post("/", dependencies=[Depends(require_permission("users.post"))])
@router.put("/{id}", dependencies=[Depends(require_permission("users.put"))])
@router.delete("/{id}", dependencies=[Depends(require_permission("users.delete"))])
```
---
## 📡 Routes

| Methos | Route | Required Permission |
|------|--------|--------|
| GET | /api/<entity> | entity.gets |
| GET | /api/<entity>/<id> | entity.get |
| POST | /api/<entity> | entity.post |
| PUT | /api/<entity>/<id> | entity.put |
| PATCH | /api/<entity>/<id> | entity.patch |
| DELETE | /api/<entity>/<id> | entity.delete |
| POST | /api/<entity>/<id>/assign | entity.assign |
| POST | /api/<entity>/<id>/remove | entity.remove |


## 🔓 Public DTO Endpoint

```code
GET /api/<entity>/options
```
---
## ⚠️ Errors

| Error | Meaning | Contex| Example |
|--------|--------|--------|--------|
| 401 | Unauthorized | Token Missing/Invalid/Expired | User is not authenticated |
| 403 | Forbidden | User lacks required `entity.action` permission | user does not have permission to access the entity |
| 404 | Not Found | Entity ID does not exist | user does not exist |
| 409 | Conflict | Unique Constraint Violation | duplicate email |
| 422 | Validation Error | Invalid Input | invalid email |
| 500 | Server Error | Internal Server Error | database connection error |

## ⚡ Performance

### Permission Cache
```code
user:{id}:perms:{version}
```
---
## 🔁 Cache Invalidation
- RolePermission change
- UserRole change
---

# 🌐 7. Angular (Web)
## 🛡 Route Guard
```ts
{
  path: 'users',
  canActivate: [permissionGuard],
  data: { requiredPermission: 'users.gets' }
}
```
---
🎛 Permission Service  (यह देखना है)
```ts
@Injectable({ providedIn: 'root' })
export class PermissionService {
  private readonly permissions = signal<Set<string>>(new Set());

  setPermissions(perms: string[]): void {
    this.permissions.set(new Set(perms));
  }
}
```
```ts
has(permission)
any(permissions[])
all(permissions[])
canSeeEntity(entity) => entity.gets
}
```
---
## 🎯 UI Rules
Mandatory Actions:
| UI Element| Required Permission |
|------|--------|
| Module/Page Access | entity.gets |
| Add New Button | entity.post |
| Edit Row/Button/Link | entity.put / entity.patch |
| Delete Row/Button/Link | entity.delete |
| View Row/Button/Link | entity.get |

---

👉 **Golden Rule for UI:** If `hasPermission('entity.action')` is false, completely remove the element from the DOM (e.g., `*ngIf`). Disable (`disabled=true`) is not enough for security.

---
# 📱 8. Flutter (Mobile)
- Same permission model as Angular
- Same API contract
- Same route structure
---
# 🧪 9. Testing Matrix
|User Role | API Action Attempted | Expected HTTP Result |
|------|--------|--------|
| Viewer | `GET /api/users (users.gets)` | ✅ 200 OK |
| Viewer | `POST /api/users (users.post)` | ❌ 403 Forbidden |
| Viewer | `DELETE /api/users/1 (users.delete)` | ❌ 403 Forbidden |

| admin | `GET /api/users (users.gets)` | ✅ 200 OK |
| admin | `POST /api/users (users.post)` | ✅ 201 Created |
| admin | `DELETE /api/users/1 (users.delete)` | ✅ 200/204 Success|
---
#🚀 10. Extension Strategy (Adding New Modules)
1. Registry Update: Add `"new_entity": [...]` to `PERMISSION_REGISTRY`.
2. Backend: Create router, apply `@require_permission()` decorators.
3. Frontend: Add route guard and UI conditional checks.
4. Seed DB: Run permission seeder script to inject new permissions into DB and map to Admin role.

---
# 🔥 FINAL SUMMARY
## System Type
- Entity-based RBAC
- Permission-based RBAC
- Action-based RBAC
- Fine-grained RBAC
- Production-ready

# 🚀 Extension Ready
- New entity add करो → registry में add करो
- Backend + frontend automatically aligned

# 💡 Golden Rule
-❗ अगर entity.gets नहीं है तो उस entity के सभी actions को भी नहीं होगा
- 👉 तो user को उस entity का existence भी नहीं दिखना चाहिए
- Each entity is a module
- Each module has its own permission registry
- Each module has its own backend
- Each module has its own frontend
- Each module has its own tests
- Each module has its own docs
- Each module has its own migrations
- Each module has its own models