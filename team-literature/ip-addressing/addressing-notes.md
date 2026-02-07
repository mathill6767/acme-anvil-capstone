# Network Mapping Notes

## IP Mapping (Excel)
- One worksheet per site
- Lists WAN, core servers, and DMZ systems
- Intended for quick reference and audits

## VLAN Map (CSV)
- Used for firewall rules, switch configs, and documentation
- One row per VLAN
- Easily imported into spreadsheets, scripts, or diagrams

## Design Notes
- Static IPs are allocated from .10–.49 ranges
- DHCP pools start at .100 for all client VLANs
- DMZ hosts never initiate traffic into LANs
- VPN terminates on pfSense WAN interfaces

## Git Usage
- Treat Excel as reference (binary)
- CSV + Markdown are source-of-truth artifacts
