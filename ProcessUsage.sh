#!/bin/bash
# ProcessUsage.sh
# Script finds the top 5 cpu-using processes and asks the user before killing it 

#Prompt the user with the processes

echo "Top 5 CPU-consuming processes:"

ps -eo pid,user,%cpu,lstart,comm --sort=-%cpu | head -n 6

# Ask the user if wants to kill the processes

echo
read -p "Do you want to kill processes from this list? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then

	echo "No processes were killed, exiting......."
	exit 0
fi

echo "Proceeding to kill processes...."

# Get current date and time for the log filename
current_date=$(date +%Y-%m-%d)
log_file=~/ProcessUsageReport-$current_date.log

# Initialize kill counter
killed_count=0

ps -eo pid=,user=,lstart=,comm= --sort=-%cpu | head -n 5 | while read -r  pid user mon day time year  start cmd; do

# Skip empty lines
 [[ -z "$pid" ]] && continue

if [[ "$user" != "root" ]]; then
# Kill the process
	kill -9 "$pid" 2>/dev/null

# Get the user primary group
department=$(id -gn "$user" 2>/dev/null)

# Log process info
echo "User: $user | Department: $department | started: $mon $day $time $year | killed: $(date) | PID: $pid | command: $cmd" >> "$log_file"

((killed_count++))

fi
done

echo "--------------------------------------------------------------------"
echo "Log file saved to: $log_file"
echo "Total processes killed: $killed_count"
echo "--------------------------------------------------------------------"
