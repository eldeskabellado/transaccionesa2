# Project Context

## Purpose

**Despacha2** is the main Delphi VCL desktop application for business management (punto de venta / ERP ligero). It covers the full commercial cycle: sales invoicing, purchasing (CXP), accounts receivable (CXC), inventory control, price lists, payment orders, barcode printing, and label generation. The system integrates WhatsApp notifications via Baileys and Evolution APIs.

> **Scope note:** Active development is focused exclusively on **Despacha2** (`Despacha2.dpr`). The other projects in this repository — **Gerencia**, **ECOMHOTEL**, and **EnvioSMS** — are out of scope unless explicitly stated.

## Tech Stack

- **Language**: Delphi (Object Pascal) — Embarcadero RAD Studio
- **UI Framework**: VCL (Visual Component Library) — Windows desktop
- **Database**: DBISAM (Elevate Software) — embedded file-based DB; tables accessed via `TDBISAMTable` and `TDBISAMQuery`
- **In-memory data**: FireDAC `TFDMemTable` + `TClientDataSet` / `TDataSetProvider` for intermediate result sets
- **Reporting**: FastReport 3/4 (`.fr3` report templates)
- **Encryption**: Custom AES-256, MD5, SHA-256, Base64 units (`SeAES256`, `SeMD5`, `SeSHA256`, `SeBase64`, `SeStreams`, `SeEasyAES`, `cifrado`, `UCipher`, `UHashes`)
- **WhatsApp Integration**:
  - Evolution API (`Evolution\EvolutionAPI.pas`, `EvolutionConfigReader.pas`, `ConfigEncryption.pas`)
  - Baileys API (`BaileysAPI.pas`)
- **SCIM/fiscal validation**: `sicm.pas` — handles fiscal number (NIT/RIF) verification
- **Configuration**: INI files read via `unitVariables.pas` (using `TIniFile`); global constants in `UnitVariablesGlobales.pas`

## Project Conventions

### Code Style

- **Naming**: Pascal-case for types (`TFormVerificar`), camelCase-leaning for variables; field components follow the convention `fieldTableNameFIELD_NAME` (e.g., `fieldFacturasFCC_SERIE`).
- **Unit names**: Prefix `Unit` for form units (e.g., `UnitPrincipal`, `UnitFormProductos`); no prefix for library/utility units (e.g., `funciones`, `cifrado`, `sicm`).
- **Form names**: Classes prefixed with `T`, instances without (e.g., class `TForm2`, global `Form2`). Modal dialogs use `ShowModal`; non-modal forms use `Show`.
- **DataModule**: Single shared `TDataModule` instance `d` (class `Td`) declared in `UnitDatos`; all DBISAM tables and queries live here.
- **Global variables**: Declared in `unitVariables.pas` (runtime config, connection params, flags like `USAR_BAILEYS`) and `UnitVariablesGlobales.pas` (file paths like `NombreArchivoClientes`).
- **Comments**: Spanish language throughout; inline comments explain business logic.
- **Error handling**: `try/finally` for resource cleanup; `try/except` for user-visible errors with `ShowMessage`.

### Architecture Patterns

- **Data Access**: Direct DBISAM table/query components on the shared DataModule. No ORM or repository abstraction — business logic is written directly in form code against `TDBISAMTable`/`TDBISAMQuery`.
- **Forms as controllers**: Each major business function has its own form unit (e.g., `UnitFormProductos`, `UnitOrdenPago`). Logic is split between `OnClick`/`OnChange` event handlers.
- **Lazy form creation**: Heavy forms (e.g., `formCXP`) are created on demand with `TformCXP.Create(nil)` and freed after use rather than created at startup.
- **Multi-project shared units**: Core utility units (`cifrado`, `sicm`, `funciones`, encryption units) are shared across all `.dpr` projects.
- **WhatsApp notifications**: Sent asynchronously after key transactions (sales, invoices) via `EvolutionAPI` or `BaileysAPI`; selection controlled by the `USAR_BAILEYS` config flag.
- **Report generation**: FastReport templates (`.fr3` files) loaded and previewed/printed from form code.

### Testing Strategy

- No automated test framework is currently in use.
- Verification is done manually by running the compiled application against a local DBISAM test database.
- Critical paths (login, invoice save, inventory update) should be tested end-to-end against a copy of production data before deployment.

### Git Workflow

- Single main branch (`main` or `master`); feature work may be done on short-lived branches.
- Commits should reference the business feature or fix in Spanish (matching the codebase language).
- Build artifacts (`Win32/`, `__history/`, `__recovery/`, `*.dcu`, `*.identcache`, `*.local`) are excluded from commits.

## Domain Context

- **Fiscal / legal**: The system operates in Venezuela. Documents reference **RIF** (tax ID), **NIT**, **facturas** (invoices), **libros de compra/venta** (purchase/sales ledgers), **tasa BCV** (official exchange rate from Banco Central de Venezuela), IVA (VAT), and **SENIAT** compliance requirements.
- **Currency duality**: Prices and costs are tracked in both **VES (bolívares)** and **USD**. The BCV official rate (`tasa_oficial_bcv`) is stored in the database and used to convert between currencies. Every invoice records both the transaction rate and the official rate.
- **Product catalog**: Products (`artículos`) have SKU codes, multiple price levels (P01–Pn), presentation units, and batch/lot tracking (`UnitLote`). Alcoholic beverages (`licores`) have additional fields: graduation, capacity, national/imported flag.
- **Payment methods**: Sales support multiple payment methods including cash (VES/USD), bank transfer, and barter ("especie"). Payment data is serialized into BLOB fields.
- **WhatsApp notifications**: After invoicing and purchasing events the system sends WhatsApp messages to clients/suppliers via Evolution API (cloud-hosted at `evolution.ek2.online`) or Baileys (self-hosted). The instance and API key are stored in the INI config file and encrypted at rest.
- **SCIM verification**: `sicm.pas` validates fiscal/identity numbers against an external registry during invoice processing.

## Important Constraints

- **Windows-only**: The VCL framework and DBISAM engine require Windows. No cross-platform builds.
- **DBISAM version lock**: The project targets a specific DBISAM version; table formats are binary-compatible only with that version. Schema changes require DBISAM table restructure operations and may involve index rebuilds.
- **Single-user or LAN deployment**: DBISAM is a file-server engine; concurrent access requires all clients to share the same network path to the DB folder. The DB path is stored in the INI config (`G_DireccionTP3` / similar variables).
- **No migrations framework**: Schema changes are applied manually via DBISAM restructure or SQL scripts run against the local engine.
- **Delphi version compatibility**: Code uses VCL + FireDAC + standard RTL — avoid features not available in the target RAD Studio version (confirm with team before using new compiler directives).

## External Dependencies

| Dependency | Purpose | Notes |
|---|---|---|
| **DBISAM** (Elevate Software) | Embedded relational DB engine | File-based; tables in TP3 subfolder |
| **FastReport** | Report generation and printing | `.fr3` template files in project root |
| **Evolution API** | WhatsApp messaging (cloud) | Hosted at `evolution.ek2.online`; key stored encrypted in INI |
| **Baileys API** | WhatsApp messaging (self-hosted) | Alternative to Evolution; toggled via `USAR_BAILEYS` flag |
| **FireDAC** (Embarcadero) | In-memory tables (`TFDMemTable`) | Bundled with RAD Studio |
| **INI config file** | Runtime configuration | Read by `unitVariables.pas` on startup |
