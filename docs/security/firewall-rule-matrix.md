# Firewall Rule Matrix (pfSense)

This matrix documents *intended* inter-VLAN/WAN flows for the simulated environment.
Default posture: **deny inter-VLAN**, then allow only what is listed.

> Notes
> - pfSense performs inter-VLAN routing (SVIs) and VPN termination.
> - IDS/IPS (Snort) runs on pfSense and inspects relevant interfaces.
> - Ports listed are typical; adjust to match your final service configs.

## Zones / VLANs
- **WAN**: 10.0.179.0/24 (simulated public)
- **SERVER (Main)**: 172.16.40.0/24
- **DMZ (Main)**: 172.16.50.0/24
- **STAFF (Main)**: 172.16.10.0/24
- **STUDENTS (Main)**: 172.16.20.0/24
- **PRINTERS (Main)**: 172.16.30.0/24
- **GUEST (Main)**: 172.16.99.0/24  
Remote sites mirror these roles in 172.20.0.0/16 and 172.30.0.0/16.

## Core Services (Main Site)
- DC1: 172.16.40.10
- FILE01: 172.16.40.11
- SIEM01: 172.16.40.12
- PRINT01 (CUPS): 172.16.40.13
- WEB01 (DMZ): 172.16.50.10

---

## Rule Matrix (High Level)

| Source Zone | Destination Zone | Allow | Ports/Protocols | Purpose |
|---|---|---:|---|---|
| WAN | DMZ (WEB01) | ✅ | TCP 80/443 | Public web access (NAT VIP 10.0.179.234 → 172.16.50.10) |
| WAN | pfSense (VPN) | ✅ | UDP 1194 (OpenVPN) **or** UDP 51820 (WireGuard) **or** UDP 500/4500 (IPsec) | Remote access VPN termination |
| DMZ | SERVER (DC1) | ✅ (minimal) | TCP/UDP 53, TCP 389/636, TCP 88 | Web auth (Authelia) to LDAP/LDAPS + DNS + Kerberos as needed |
| DMZ | SERVER (SIEM01) | ✅ | TCP/UDP 1514, TCP 1515 | Wazuh agent/forwarding from DMZ host |
| DMZ | Any LAN (Staff/Students/Guest) | ❌ | — | Block DMZ from initiating into user networks |
| STAFF | SERVER (DC1) | ✅ | TCP/UDP 53, TCP/UDP 88, TCP 135, TCP/UDP 389, TCP 445, TCP 464, TCP 3268/3269, UDP 123 | AD/DNS auth, group policy, domain services, time |
| STAFF | SERVER (FILE01) | ✅ | TCP 445 | SMB access to shares |
| STAFF | SERVER (PRINT01) | ✅ | TCP 631 | Printing via CUPS |
| STAFF | DMZ (WEB01) | ✅ | TCP 443 | Access internal/external web apps via reverse proxy |
| STUDENTS | SERVER (DC1) | ✅ (limited) | TCP/UDP 53, TCP/UDP 88, TCP/UDP 389 (or 636), UDP 123 | Domain auth + DNS + time (limit admin ports) |
| STUDENTS | SERVER (FILE01) | ✅ (optional) | TCP 445 | Only if students need share access (otherwise deny) |
| STUDENTS | SERVER (PRINT01) | ✅ | TCP 631 | Printing |
| STUDENTS | DMZ (WEB01) | ✅ | TCP 443 | Access allowed web resources |
| PRINTERS | SERVER (PRINT01) | ✅ | TCP 631 | Printers talk to CUPS/IPP |
| PRINTERS | STAFF/STUDENTS | ❌ | — | Block printers initiating to users |
| GUEST | Any Internal | ❌ | — | Guest = internet-only |
| GUEST | WAN | ✅ | TCP/UDP 53, TCP 80/443 | DNS + web only (optional captive portal) |
| Any Internal | SIEM01 | ✅ | TCP/UDP 1514, TCP 1515 (Wazuh) | Agent → SIEM logging |
| pfSense | SIEM01 | ✅ | UDP 514 (syslog) or agent | Firewall/VPN/IDS logs into SIEM |

---

## Suggested “Default Deny” Baselines
- Deny **DMZ → LAN**, allow only DMZ → DC1 (LDAP/DNS) and DMZ → SIEM.
- Deny **Printers → LAN**, allow only Printers → PRINT01.
- Deny **Guest → Internal**, allow only Guest → WAN (DNS + 80/443).
- Students get only what they need: usually **AD/DNS**, **printing**, and **HTTPS**.

## Remote Sites (High Level)
- Site-to-site VPN tunnels: allow the same logical flows between site VLANs and Main services.
- Printers at remote sites should be able to reach PRINT01 (CUPS) and/or maintain local queues.
