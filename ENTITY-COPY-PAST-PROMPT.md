Use the master structured workflow and run in Assisted mode.

Goal:
I want to implement a new entity: <ENTITY_NAME>.
You must prepare everything even if details are incomplete.

Instructions:
1) Create/Update schema spec file: ai/schema/<entity_key>.md
2) Create filled ENTITY_INPUT file: ai/enity_input/entity_input.<entity_key>.yaml
3) If any field details are missing, propose safe production defaults and clearly mark them as ASSUMPTION.
4) Keep RBAC naming strictly: entity.get, entity.gets, entity.post, entity.put, entity.patch, entity.delete (optional: options/combobox only if needed).
5) Ensure naming consistency:
   - DB/table/columns: snake_case
   - API routes: kebab-case
   - permission key: entity.action
6) Include:
   - fields (type, nullable, default, enum)
   - constraints (unique, FK, checks)
   - indexes
   - seed data (if applicable)
   - migration metadata (revision_id, revision_name, down_revision)
   - web list columns, filters, sort, validations
   - mobile required true/false
7) Output in this order:
   - Summary
   - ai/schema/<entity_key>.md content
   - ai/enity_input/entity_input.<entity_key>.yaml content
   - Assumptions list
   - Open questions (only critical ones)

Input context:
- Entity name: <ENTITY_NAME>
- Entity key (snake_case): <entity_key>
- Module group: <Masters|Transactions|Inventory|Other>
- Rough business notes: <paste your notes here>
