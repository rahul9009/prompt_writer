#.ai/schema/ledger_group.md
You are the Entity Agent.

Follow: PROMPT.md, SCAFFOLD_RULES.md, ROADMAP.md (Phase 2), and .ai/entity.prompt.md.

Entity: Ledger Groups
Fields: 
- id (uuid, primary key)
- alias (string, nullable:true)
- name (string, nullable:false)
- parent_id (uuid, nullable:true, foreign key to ledger group id)
- nature (enum: Asset, Liability, Income, Expense, nullable:true)
- reporting_category_name (enum: BalanceSheet, ProfitAndLoss, nullable:false)
- reporting_side (enum: Left, Right, nullable:false)
- default_balance (enum: DR, CR, nullable:true) - the default balance of this ledger group
- purchase_invoice_alloc_method (enum: NotApplicable, ByValue, ByQty, nullable:true) - the purchase invoice allocation method of this ledger group
- sort_order (int, nullable:true) - the sort order of this ledger group
- affects_gross_profit (bool, nullable:true) - whether this ledger group affects gross profit
- behaves_like_subledger (bool, nullable:true) - whether this ledger group behaves like a subledger
- is_active (bool, nullable:false) - whether this ledger group is active
- is_reserved (bool, nullable:false) - whether this ledger group is reserved
- net_balance_for_reporting (bool, nullable:false) - whether this ledger group is used for reporting
- used_for_calculation (bool, nullable:false) - whether this ledger group is used for calculation

Constraints: 
- unique name per parent
- required name
- required nature
- required reporting_category_name
- required reporting_side
- required default_balance
- required purchase_invoice_alloc_method
- required sort_order
Permissions: auto-generate ledger_group.create/read/update/delete/combobox

Seed data:
- Asset:
  - name: "Cash"
  - parent_id: null
  - nature: "Asset"
  - reporting_category_name: "BalanceSheet"
  - reporting_side: "Left"
  - default_balance: "DR"
  - purchase_invoice_alloc_method: "NotApplicable"
  - sort_order: 1
  - affects_gross_profit: false
  - behaves_like_subledger: false
  - is_active: true
  - is_reserved: false
  - net_balance_for_reporting: true
  - used_for_calculation: true

Deliver end-to-end:
- Postgres migration + indexes
- FastAPI CRUD + validation + tests
- Angular list/detail/form + route guard + nav update
- Flutter list/detail/form (if required)
- Update permission seeds (if needed)

Alembic revision: "002_ledger_group"
Alembic revission id: "002"
Alembic revission Title: "Ledger Group"
Alembic down_revision: "001"
Alembic branch_labels: None
Alembic depends_on: None

Alembic migration:
- create table
- add indexes
- add constraints
- add seed data
- add permissions
- add tests
- add documentation
- add notes
- add changelog
- add release notes
