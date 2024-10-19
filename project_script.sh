#! /bin/bash

# Function to display the Linux version
display_linux_version() 
{
    echo "Linux Version: $(uname -r)";
}

# Function to display network details
display_network_details() 
{
    echo "====>> Network Details";
    echo "Private IP Address: $(hostname -I | awk '{print $1}')";
    echo "Public IP Address: $(curl -s ifconfig.co)";
    echo "MAC Address (Masked): $(ip link show | grep ether | awk '{print $2}' | sed 's/^\(..:..:..\):.*/\1:XX:XX:XX/')";
    #echo "MAC Address (Full): $(ip link show | grep ether | awk '{print $2}')";
}

# Function to display memory statistics
display_memory_statistics() 
{
    echo "====>> Memory Usage Statistics";
    echo "Disk usage: $(df -h --output=source,size,used,avail,pcent | grep '^/dev/')";
    free -h | awk '/^Mem:/ {print "Total Memory: " $2 "\nAvailable Memory: " $7}'
    
}

# Function to display large directories and files
display_files_and_directories()
{
	echo "====>> The five largest directories:";
	du ah / 2>/dev/null | sort -rh | head -n 5
	echo
	echo "====>> Top 10 Largest Files in /home:"
	find /home -type f -exec du -h {} + | sort -rh | head -n 10
}

# Function to monitor CPU usage
monitor_cpu_usage()
{
	echo "====>> CPU Usage";
	mpstat 1 1 | awk '/^Average/ {print "CPU Usage: " 100 - $NF "%"}'
	echo "Top 5 Processes by CPU Usage:"
	ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Function to list active system services
active_system_services()
{
	echo "====>> Active system services";
	systemctl list-units --type=service --state=running | awk '{print $1, $4}'
}
	
# Main loop
while true; do
    clear
    display_linux_version
    echo
    display_network_details
    echo
    display_memory_statistics
    echo
    monitor_cpu_usage
    echo
    active_system_services
    echo
    display_files_and_directories
    echo
    echo "Refreshing in 10 seconds..."
    sleep 10
done
