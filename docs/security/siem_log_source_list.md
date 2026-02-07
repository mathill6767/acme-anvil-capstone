# SIEM (Wazuh) Log Source List

This list defines what should send logs/events to **SIEM01 (Wazuh)** and what value each source provides.

**SIEM01 (Wazuh):** 172.16.40.12

## Priority 1 (Must-Have)

### pfSense (Firewall / Router / VPN)
- **Logs:** firewall rule hits, NAT, VPN auth/connect/disconnect, DHCP (if used), DNS resolver (if used)
- **Method:** Syslog to SIEM01 (UDP 514) *or* Wazuh agent where supported
- **Why:** single best visibility source for traffic + VPN activity

### Snort (IDS/IPS on pfSense)
- **Logs:** alerts, signatures triggered, blocked events
- **Method:** forward Snort alerts via syslog or filebeat/agent depending on setup
- **Why:** detection + evidence for attacks and policy violations

### Windows Domain Controller (DC1)
- **System/Security:** login success/failure, account lockouts, group membership changes
- **AD audit:** GPO changes, privileged actions
- **DNS logs:** (optional) queries/blocks if enabled
- **Method:** Wazuh agent on DC1, enable relevant audit policies
- **Why:** identity layer = high signal

### FILE01 (SMB File Server)
- **Logs:** file access, share access failures, permission changes
- **Method:** Wazuh agent
- **Why:** tracks data access and abuse

### WEB01 (DMZ Web/Auth/WAF)
- **NGINX:** access/error logs
- **Authelia:** auth attempts, MFA events
- **ModSecurity:** WAF alerts and anomaly scores
- **Method:** Wazuh agent + log collection rules
- **Why:** internet-facing system telemetry

## Priority 2 (Strongly Recommended)

### PRINT01 (CUPS)
- **Logs:** job submissions, failures, queue activity, admin changes
- **Method:** Wazuh agent (Linux) collect `/var/log/cups/*`
- **Why:** useful for abuse/tracking + operational troubleshooting

### Endpoints (Staff/Student Workstations)
- **Windows event logs:** process creation (if enabled), logon events, Defender alerts (if enabled)
- **Method:** Wazuh agent on representative endpoints (at least 1 staff + 1 student per site)
- **Why:** catches malware / suspicious behavior at the edge

### Remote Site pfSense instances
- **Logs:** same as main pfSense + site VPN status
- **Method:** syslog to SIEM01 through site-to-site VPN
- **Why:** full multi-site visibility

## Priority 3 (Nice-to-Have / If Time)

### DHCP logs (if provided by pfSense or Windows)
- **Why:** ties device identity to IP lease history

### Pi-hole (if used)
- **Logs:** DNS queries/blocks per client
- **Why:** phishing/malware domain visibility

### Switch/Virtual Network (if simulated)
- **Logs:** port up/down, admin actions
- **Why:** adds infrastructure evidence

---

## Minimal “Capstone Demo” Log Sources (if you need to cut scope)
1. pfSense + Snort
2. DC1
3. WEB01 (NGINX + Authelia + ModSecurity)
4. FILE01
5. One endpoint (staff) + one endpoint (student)
