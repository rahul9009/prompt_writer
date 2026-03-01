#.ai/docs/ui/UI_SCAFFOLD_RULES.md
You are an Expert Angular Architect & UI/UX Designer.

**GOAL**
Generate a production-ready, visually stunning Angular "Entity Hub" scaffold using Angular Material. The hub organizes multiple entities under dynamically generated main tabs.

**TECH STACK & STANDARDS**
- Angular (Latest) - MUST use Standalone Components (`standalone: true`) and modern Control Flow (`@if`, `@for`).
- State Management: Use Angular Signals for UI state and RxJS streams strictly for async API orchestration (search debounce, refetching).
- Angular Material: MatTabGroup, MatTable, MatPaginator, MatSort, MatDialog, MatFormField, MatInput, MatButton, MatIcon, MatBadge, MatProgressBar, MatSnackBar, MatSidenav/MatNavList.
- Styling: SCSS using strict theme tokens/CSS variables.

**ENTITY GROUPING & DATA MODEL (DYNAMIC CONFIGURATION)**
The tabs and entities must NOT be hardcoded. They must be generated from a central configuration file. 
*EntityConfig Map:* Create an `entity-config.ts` exporting a strictly typed configuration map defining groups (which become the main Tabs) and their child entities. 
Define per-entity:
- `entityKey` (string)
- `displayName` (string)
- `listColumns` (string array)
- `defaultSort` ({ active: string, direction: 'asc'|'desc' })
- `filterSchema` (placeholder interface)
*Populate this config with 2-3 generic placeholder groups and a few dummy entities just to demonstrate the working scaffold.*

**UI STRUCTURE & NAVIGATION BEHAVIOR**
1. **Header:** Title "Entities Hub" with a breadcrumb placeholder.
2. **Main Layout:** Use `MatTabGroup` to iterate over the groups defined in `entity-config.ts`.
3. **Inner Navigation (Pattern A Enforced):** Inside each tab, implement a split-pane layout using `MatSidenav` or a CSS Grid layout.
   - Left side: `MatNavList` displaying entities for that tab. Utilizes a router-less selection state (Signals).
   - Right side: Content area rendering the reusable `EntityListingComponent` inside a modern, slightly elevated card container.

**ENTITY LISTING PAGE RULES (Reusable Component)**
- **Toolbar:** - Left: Search input (RxJS debounced 300ms) with a clear 'x' button.
  - Right: Filter button (opens `FilterDialog`) with a `matBadge` showing active filter count.
  - Right: 'Add New' button (opens `AddEditEntityDialog`, use `mat-flat-button` with primary color).
- **Data Table UX:** - `MatTable` with dynamic columns based on `EntityConfig`.
  - Enforce a **Sticky Header** for the table so it scrolls beautifully.
  - Add a subtle hover background color on table rows using Material surface tokens.
  - Final column MUST be `actions` containing Edit/Delete `mat-icon-button`s.
- **Empty & Loading States:** - Show a `<mat-progress-bar mode="query">` at the top of the table when loading.
  - Implement a beautiful **Empty State** (an icon and muted text like "No records found") using `@if` when data length is 0.
- **Pagination:** `MatPaginator` below the table (pageSizeOptions: [10, 20, 50, 100]).

**DESIGN, UX & THEMING (MATERIAL 3 STANDARDS)**
- **Forms:** All `MatFormField` elements MUST use `appearance="outline"`.
- **Colors & Tokens:** Strictly use Material 3 CSS variables (e.g., `var(--mat-sys-surface-container)`, `var(--mat-sys-on-surface-variant)`). Zero hardcoded hex colors.
- **Typography & Spacing:** Ensure clear hierarchy. Table headers should be slightly muted (on-surface-variant), and spacing around the toolbar, table, and paginator must be uniform (e.g., 16px to 24px padding).
- **Transitions:** Add smooth CSS transitions (`0.2s ease-in-out`) to row hovers and sidebar collapsing.
- **Responsive:** On mobile screens, the left entity menu collapses into a horizontal scroll or dropdown. Toolbar search expands to full width, and buttons wrap cleanly.
- **Accessibility:** `aria-label`s on all icon buttons, ensure dialogs trap focus and close on ESC.

**STATE & RXJS DATA FLOW**
- Maintain global state via Signals.
- Maintain listing state via Signals/RxJS.
- Build a reactive RxJS pipeline that triggers a data refetch when any of the following emit: entity change, search change (debounced), filter apply, sort change, or paginator change.

**MOCK API SERVICE**
Provide an `EntityService` stub with strongly typed placeholders returning Observables.

**DELIVERABLES**
Provide the HTML, TS, and SCSS for:
1. `entity-config.ts`
2. `entity-service.ts`
3. `entity-hub.component` (html, ts, scss)
4. `entity-listing.component` (html, ts, scss)
5. `add-edit-entity-dialog.component` (html, ts, scss)
6. `filter-dialog.component` (html, ts, scss)