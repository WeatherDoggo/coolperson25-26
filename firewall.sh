#!/bin/bash
LOG=./logs/main.log
function print() {
  echo -e "$1" | sudo tee -a "$LOG" 
}

#Basic Firewall Conf
print "Enabling firewall..."
apt-get install ufw -y -qq >> $LOG
apt-get purge iptables-persistent -y -qq >> $LOG
print "iptables-persistent removed."
ufw enable >> $LOG
ufw default deny incoming >> $LOG
ufw default allow outgoing >> $LOG
ufw default deny routed >> $LOG
ufw logging on
ufw deny 1337 >> $LOG

#loopback config
ufw allow in on lo
ufw allow out on lo
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
systemctl enable ufw.service --now >> $LOG
print "Firewall enabled, port 1337 closed, and loopback traffic is configured."
#MAKE IT SO LISTENING PROCESSES IS CHECKED BEFORE CLOSING PORT 1337!!!!!!!

{
  unset a_ufwout;unset a_openports
  while read -r l_ufwport; do
    [ -n "$l_ufwport" ] && a_ufwout+=("$l_ufwport")
  done < <(ufw status verbose | grep -Po '^\h*\d+\b' | sort -u)
  while read -r l_openport; do
    [ -n "$l_openport" ] && a_openports+=("$l_openport")
  done < <(ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ && $5!~/\[?::1\]?:/) {split($5, a, ":"); print a[2]}' | sort -u)
  a_diff=("$(printf '%s\n' "${a_openports[@]}" "${a_ufwout[@]}" "${a_ufwout[@]}" | sort | uniq -u)")
  if [[ -n "${a_diff[*]}" ]]; then
    echo -e "\n- Audit Result:\n ** FAIL **\n- The following port(s) don't have a rule in UFW: $(printf '%s\n' \\n"${a_diff[*]}")\n- End List"
  else
    echo -e "\n - Audit Passed -\n- All open ports have a rule in UFW\n"
  fi
}
print "For each port in the audit that does not have a firewall rule, evaluate the service listening port and add a rule accepting or denying inbound connections (ex. ufw allow in <port>/<tcp or udp protocol>):"
read portconfirm
