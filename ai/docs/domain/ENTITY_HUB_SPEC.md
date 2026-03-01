#.ai/docs/domain/ENTITY_HUB_SPEC.md
# 🧩 ENTITY_HUB_SPEC.md

---

# 🎯 Purpose

This document defines the **Entity Hub structure**, grouping of entities, navigation behavior, and configuration required to build a scalable, permission-aware UI system.

It acts as a **domain-level source of truth** for:
- Entity grouping (Tabs)
- UI navigation structure
- Entity metadata
- Integration with RBAC (.ai/docs/rbac/SCAFFOLD_RULES.md)

---

# 🧱 1. Core Concepts

## 📦 Entity = Module
- Each entity is treated as an independent module
- Each module has:
  - Backend API
  - Permission set (`entity.action`)
  - UI listing page
  - Forms (Create/Edit)
  - Filters

---

## 🧭 Entity Hub
- A centralized UI page to access all entities
- Organized into logical groups (Tabs)
- Each tab contains multiple entities

---

# 🗂️ 2. Entity Grouping (MANDATORY)

## 🟦 Tabs Structure

### 1. Masters
- LedgerGroup
- Ledger
- ItemGroup
- Item
- ItemCategory
- ItemSubCategory
- ItemBrand
- UnitOfMeasurement (Ex. )
- TaxCategory (Ex. GST,TDS, TCS, VAT, etc.)
- TaxGroup
- TaxType (Ex. CGST, SGST, IGST, etc.)
- Tax (Ex. CGST, SGST, IGST, etc.)
- TaxRate (Ex. 18%, 28%, etc.)
- TaxRateType (Ex. Flat, Percentage, etc.)
- TaxRateType (Ex. Flat, Percentage, etc.)
---

### 2. Transactions
- Cash
- Bank
- Payment
- Receipt
- Journal
- CreditNote
- DebitNote

---

### 3. Inventory
- PurchaseOrder
- Purchase
- PurchaseReturn
- Production
- SalesOrder
- Sales
- SalesReturn

---

# 🧩 3. Entity Configuration (Single Source)

## 📌 EntityConfig Interface

```ts
export interface EntityConfig {
  entityKey: string;
  displayName: string;
  group: 'Masters' | 'Transactions' | 'Inventory';
  listColumns: string[];
  defaultSort?: {
    active: string;
    direction: 'asc' | 'desc';
  };
  filterSchema?: Record<string, any>;
}