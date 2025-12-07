#!/bin/bash
#------------------
#InternetBlocker.sh
# Users in the IT group
# Local web server at 192.168.2.3
# It retrieves users in the IT group, creates iptables rules for them
# then drops all the other special access.


# Get list of users in the IT group
IT_USERS=$(getent group IT | awk -F: '{print $4}' | tr ',' ' ' )

# Count users
USER_COUNT=0

echo "Creating allow rules for IT group users..."
  for USER in $IT_USERS
  do
	if id "$USER" >/dev/null 2>&1; then
	   sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner "$USER" -j ACCEPT
	   sudo iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner "$USER" -j ACCEPT
	   USER_COUNT=$((USER_COUNT + 1))
	   echo " - Allowed HTTPS/HTTP FOR $USER"
	fi
 done

# Allow access to the local web server
echo "Adding allow rule for local web server 192.168.2.3..."
sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT

# Block special access ports
echo "Adding DROP rules for special-access ports..."
sudo iptables -t filter -A OUTPUT -p tcp --dport 8003 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 1979 -j DROP

# Final message
echo "------------------------------------------------------"
echo "Internet Blocker complete."
echo "Total IT users granted internet access: $USER_COUNT"
echo "------------------------------------------------------"
