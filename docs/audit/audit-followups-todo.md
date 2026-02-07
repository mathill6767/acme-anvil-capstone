# Audit Follow-Ups, Assumptions, and TODO List

This document tracks **clarifications, known assumptions, and follow-up tasks**
identified during internal review and external audit (e.g., Claude audit).

It is intentionally **non-prescriptive** and does not redefine architecture.
Its purpose is to reduce ambiguity and document intent.

---

## Status Key
- ⬜ Not started
- 🟨 In progress
- 🟩 Complete
- ℹ️ Informational / intentional decision (no action planned)

---

## 1. Known Assumptions (Intentional Design Choices)

These items are **intentional** and not considered gaps unless stated otherwise.

- ℹ️ Only the **Main Site** contains a DMZ  
  Rationale: centralization of public-facing services simplifies security controls.

- ℹ️ Single Domain Controller at Main with optional RODCs at remote sites  
  Rationale: acceptable risk in a simulated environment; RODCs documented but not mandatory.

- ℹ️ DMZ web, reverse proxy, web authentication, and WAF are on **one VM**  
  Rationale: simulation scope and resource constraints.

- ℹ️ Static IP ranges (.10–.49) are reserved but not fully exhausted  
  Rationale: allows future expansion without renumbering.

- ℹ️ IDS/IPS (Snort) runs on pfSense rather than a dedicated sensor
  Rationale: visibility is sufficient for capstone objectives.

- ℹ️ WEB01 (DMZ) is **domain-joined** to Active Directory
  Rationale: enables Authelia/LDAP integration from DMZ; accepted risk in simulated environment.
  Audit ref: M-5

- ℹ️ Remote site printers are managed centrally via **PRINT01 over VPN**
  Rationale: centralized CUPS simplifies management; VPN dependency is accepted.
  Audit ref: m-7

---

## 2. Clarifications to Confirm (Likely Audit “UNCLEAR” Items)

These items should be clarified **in documentation or verbally** if flagged.

- ⬜ Confirm whether student SMB access is required or intentionally limited  
  Affects: firewall rules, FILE01 permissions, audit expectations

- ⬜ Confirm whether DMZ web authentication uses **LDAP** or **LDAPS**  
  Affects: certificate expectations and firewall port clarity

- ⬜ Confirm whether printers communicate directly with clients or only via CUPS  
  Affects: printer VLAN firewall rules

- ⬜ Confirm whether VPN remote access users are staff-only or include admins/students
  Affects: VPN firewall policy and SIEM alerting expectations

- ⬜ Confirm which VPN protocol was selected (OpenVPN, WireGuard, or IPsec)
  Affects: firewall rules, Phase-2 selectors, remote access design; ADR-0003 is a stub
  Audit ref: M-1

- ⬜ Confirm VPN Phase-2 / tunnel selectors match documented site subnets
  Affects: multi-site connectivity; no Phase-2 documentation exists anywhere
  Audit ref: UNCLEAR checklist item

- ⬜ Confirm which web authentication system was selected (Authelia vs Keycloak)
  Affects: SSO integration; inventory references Authelia, but a Keycloak realm-export exists
  Audit ref: m-3

- ⬜ Confirm whether CUPS (PRINT01) pushes jobs to printers or printers pull from CUPS
  Affects: firewall rules — Server→Printer VLAN rules may be needed if push mode
  Audit ref: m-6

- ⬜ Confirm SIEM (Wazuh) implementation status — log source list is well-defined but ossec.conf is an empty stub
  Affects: audit confidence that Priority-1 log sources are actually ingested
  Audit ref: M-3

- ⬜ Confirm AD OU structure and security group design — ou-structure.md and groups.md are stubs
  Affects: GPO linkage clarity, SMB permissions, printer access policies
  Audit ref: M-4

---

## 3. Post-Audit TODOs (Only If Findings Require It)

These tasks should only be acted on **after reviewing the audit report**.

- ⬜ Add a short “DNS flow overview” note (who queries whom)
- ⬜ Add a short “Time/NTP source” note (pfSense vs DC vs external)
- ⬜ Add a one-paragraph note acknowledging single points of failure
- ⬜ Add explicit mention of certificate usage (self-signed vs internal CA)

- ⬜ Clarify VLAN ID 60 for Main Servers — remote sites use 140/240 (base-40 offset) but Main uses 60, not 40
  Risk: implementer may misconfigure switch VLAN trunks following the wrong pattern
  Audit ref: C-1 (Critical)

- ⬜ Export actual pfSense configs (redacted) for all 3 sites — current exports are 1-2 line stubs
  Risk: no implementation evidence exists to verify the firewall rule matrix is applied
  Audit ref: C-2 (Critical)

- ⬜ Prioritize completing core documentation stubs: 01-architecture.md, 02-networking-vlans.md, ADR-0003-vpn.md, main-site.md
  Risk: ~70% of markdown files are TODO placeholders; project is not self-documenting
  Audit ref: M-2 (Major)

---

## 4. Diagram & Inventory Cross-Checks

Use this section to track cleanup if an audit flags inconsistencies.

- ⬜ Diagram hostnames match inventory CSV
- ⬜ Diagram VLAN labels match VLAN map
- 🟩 Inventory reflects correct site counts (verified: 5 staff + 15 students per site across all 3 sites)
  Audit ref: PASS checklist item
- ⬜ WAN IPs referenced consistently across docs and diagrams
- ⬜ Clarify precedence between assets.csv and device_inventory_preprovision.csv (identical data, different column names)
  Audit ref: m-1
- ⬜ Populate or remove empty meeting notes templates (week-01 through week-03)
  Audit ref: m-2

---

## 5. Audit Response Log

Record audit outcomes and how they were addressed.

| Date | Auditor | Finding Summary | Action Taken |
|-----|--------|----------------|-------------|
| 2026-02-06 | Claude | Full audit: 2 critical, 7 major, 7 minor findings | Auto-mapped into Sections 1-4 and traceability table |
| 2026-02-06 | Claude | C-1: VLAN ID 60 offset pattern discrepancy | Mapped to Section 3 |
| 2026-02-06 | Claude | C-2: pfSense config exports are empty stubs | Mapped to Section 3 |
| 2026-02-06 | Claude | M-1: VPN architecture undocumented | Mapped to Section 2 |
| 2026-02-06 | Claude | M-5: WEB01 domain-join in DMZ | Mapped to Section 1 as intentional |
| 2026-02-06 | Claude | Verdict: PASS WITH NOTES (4/10 implementation readiness) | See Section 8 traceability table |

---

## 6. Out-of-Scope (Explicitly Deferred)

These items are acknowledged but intentionally excluded.

- Advanced DLP implementation
- Dedicated proxy beyond DNS filtering
- High-availability firewall clustering
- Full endpoint EDR deployment

---

## 7. Final Notes

This document exists to:
- demonstrate design awareness
- prevent rework
- make audit feedback actionable
- show intentional scope management

---


## 8. Audit Auto-Mapping (Claude Output Integration)

This section is populated **after** an external audit (Claude) is run.

Each audit finding is mapped to exactly one of the following outcomes:
- Marked **ℹ️ Informational** if already documented as an assumption
- Added to **Clarifications to Confirm**
- Added to **Post-Audit TODOs**
- Explicitly rejected as out-of-scope

No architectural changes are made here.

### Mapping Rules
- **Critical findings** → MUST appear in Section 3 (Post-Audit TODOs)
- **Major findings** → MUST appear in Section 2 (Clarifications to Confirm)
- **Minor findings** → MAY be added to Section 4 or ignored
- **UNCLEAR checklist items** → MUST appear in Section 2 unless already listed
- **PASS checklist items** → No action required

### Audit Traceability Table

| Audit Item ID | Audit Category | Summary | Mapped To Section | Status |
|--------------|----------------|---------|-------------------|--------|
| C-1 | Critical | VLAN ID 60 for Main Servers breaks base-40 offset pattern (remote sites use 140/240) | Section 3 | ⬜ |
| C-2 | Critical | pfSense config exports are 1-2 line stubs — no implementation evidence | Section 3 | ⬜ |
| M-1 | Major | VPN architecture entirely undocumented — no protocol decision, no Phase-2 selectors | Section 2 | ⬜ |
| M-2 | Major | ~70% of documentation files are TODO stubs | Section 3 | ⬜ |
| M-3 | Major | SIEM implementation evidence missing — ossec.conf is empty despite good log source list | Section 2 | ⬜ |
| M-4 | Major | AD OU structure and groups not documented — ou-structure.md and groups.md are stubs | Section 2 | ⬜ |
| M-5 | Major | WEB01 (DMZ) is domain-joined — accepted risk, needs documentation | Section 1 | ℹ️ |
| M-6 | Major | DNS flow undocumented — Pi-hole vs DC1 resolution chain unclear | Section 3 (pre-existing) | ⬜ |
| M-7 | Major | NTP/time source not documented | Section 3 (pre-existing) | ⬜ |
| m-1 | Minor | Dual inventory files (assets.csv / device_inventory_preprovision.csv) with no stated precedence | Section 4 | ⬜ |
| m-2 | Minor | Meeting notes (week-01 through week-03) are empty templates | Section 4 | ⬜ |
| m-3 | Minor | Keycloak realm-export exists but inventory references Authelia — no ADR decision | Section 2 | ⬜ |
| m-4 | Minor | Printer count (5/site) ratio is undocumented but reasonable | N/A | ℹ️ |
| m-5 | Minor | Certificate strategy undocumented (self-signed vs internal CA) | Section 3 (pre-existing) | ⬜ |
| m-6 | Minor | CUPS push vs pull mode affects whether Server→Printer firewall rules are needed | Section 2 (merged with pre-existing) | ⬜ |
| m-7 | Minor | Remote site printers depend on central PRINT01 over VPN — accepted risk | Section 1 | ℹ️ |
| CK-VLAN | Checklist PASS | VLAN IDs unique, no overlaps, names consistent | N/A | 🟩 |
| CK-IP | Checklist PASS | No subnet overlaps; statics outside DHCP ranges | N/A | 🟩 |
| CK-HOST | Checklist PASS | All 83 hostnames consistent across all artifacts | N/A | 🟩 |
| CK-WAN | Checklist PASS | WAN IPs consistent (Main .231, RO1 .232, RO2 .233, VIP .234) | N/A | 🟩 |
| CK-DMZ | Checklist PASS | WEB01 correctly in DMZ VLAN everywhere | N/A | 🟩 |
| CK-FW | Checklist PASS | Firewall matrix: default-deny, DMZ/printer/guest isolation confirmed | N/A | 🟩 |
| CK-COUNT | Checklist PASS | 5 staff + 15 students per site verified | Section 4 | 🟩 |
| CK-OU | Checklist PASS | AD OU paths syntactically valid and consistent across 3 CSVs | N/A | 🟩 |
| CK-VPN-P2 | Checklist UNCLEAR | No VPN Phase-2 selector documentation exists | Section 2 | ⬜ |
| CK-VPN-FW | Checklist UNCLEAR | VPN flows referenced at high level but no tunnel config to validate | Section 2 | ⬜ |
| CK-PFSENSE | Checklist UNCLEAR | pfSense config.xml files are empty stubs | Section 3 | ⬜ |
| CK-SIEM | Checklist UNCLEAR | ossec.conf empty; cannot confirm log ingestion | Section 2 | ⬜ |
| CK-SNORT | Checklist UNCLEAR | snort.conf.redacted is a 2-line stub | Section 2 | ⬜ |
| CK-PIHOLE | Checklist FAIL | custom.list and adlists.txt are empty | Section 3 | ⬜ |
| CK-SMB | Checklist FAIL | permissions-matrix.csv has header only | Section 2 | ⬜ |
| CK-NGINX | Checklist FAIL | nginx.conf is a 4-line minimal placeholder | Section 3 | ⬜ |

**Audit Verdict: PASS WITH NOTES**
**Implementation Readiness: 4/10**
**Audit Date: 2026-02-06**

No architectural changes should be made solely based on this file.
