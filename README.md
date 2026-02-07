# acme-anvil-capstone

## Acme Anvil Academics – Network & Systems Documentation

This repository contains the simulated network, server, and security design
for the Acme Anvil Academics VMware-based environment.

## Scope

- Multi-site campus network
- VLAN segmentation
- Centralized authentication (AD)
- DMZ web services
- IDS/IPS, SIEM, VPN
- SMB and centralized printing (CUPS)

## Structure

- `docs/` — Architecture, networking, security, runbooks, test plans, ADRs
- `team-literature/` — Requirements, IP addressing, cost analysis, meeting notes
- `inventory/` — Asset tracking and account/role documentation
- `configs/` — Network, security, identity, and service configurations (redacted)
- `scripts/` — Export, restore, and validation scripts
- `templates/` — Configuration and environment variable templates
- `lab-notes/` — Changelog and decision log


## Sites

- Main Site
- Remote Site #1
- Remote Site #2

## Security Notice

This repository does **not** contain real secrets, keys, passwords, tokens, or certificates. All credential fields use placeholder or `REDACTED` values. Run `scripts/validate/secret_scan.sh` (or `.ps1`) before committing to verify no secrets are present.

All systems are simulated and deployed as VMware virtual machines.
