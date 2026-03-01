# Prompt Workflow (One-Time Setup + Add Entities Iteratively)

## Goal
Keep one stable master prompt and only change entity input per iteration.

## Files
- Master prompt: `ai/master_structured.prompt.md`
- Entity input template: `ai/entity_input.template.yaml`

## How to Use
1. Keep `ai/master_structured.prompt.md` unchanged as your base instruction.
2. Copy `ai/entity_input.template.yaml` for each new entity and fill all fields.
3. Send both to the coding agent in one message:
   - Master prompt content
   - Filled `ENTITY_INPUT`
   - Optional scope override (backend-only, web-only, full-stack)
4. Agent implements only requested scope, validates auth/RBAC, and returns output in the fixed delivery format.

## Recommended Command Pattern (Manual)
Use this user message pattern every time:

```text
Use ai/master_structured.prompt.md as base.
Execute with this ENTITY_INPUT:
<paste filled yaml>
Scope: full-stack
Priority: minimal safe changes
```

## Notes
- Prefer `entity.action` permissions (`get`, `gets`, `post`, `put`, `patch`, `delete`).
- Keep naming consistent: snake_case (DB), kebab-case (routes), `entity.action` (permissions).
- If mobile is not needed, set `mobile.required: false`.
