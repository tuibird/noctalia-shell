#!/bin/bash

# A script to display CPU temperature, CPU usage, memory usage, and disk usage without the 'sensors' package.

echo "--- System Metrics ---"

# Get CPU Temperature in Celsius from a kernel file.
# This method is more common on modern systems but may vary.
# It reads the temperature from the first available core.
# Function to get CPU temperature

    # Check for the common thermal zone path
    if [ -f "/sys/class/thermal/thermal_zone0/temp" ]; then
        temp_file="/sys/class/thermal/thermal_zone0/temp"
    # Check for a different thermal zone path (e.g., some older systems)
    elif [ -f "/sys/class/hwmon/hwmon0/temp1_input" ]; then
        temp_file="/sys/class/hwmon/hwmon0/temp1_input"
    else
        echo "Error: Could not find a CPU temperature file."
        exit 1
    fi

    # Read the raw temperature value
    raw_temp=$(cat "$temp_file")

    # The value is usually in millidegrees Celsius, so we divide by 1000.
    temp_celsius=$((raw_temp / 1000))
    
    echo "CPU Temperature: ${temp_celsius}°C"


# Get CPU Usage
# 'top' is a standard utility for this. It gives a real-time view of system processes.
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU Usage: ${cpu_usage}%"

# Get Memory Usage
# 'free' provides information about memory usage.
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_usage=$((100 * mem_used / mem_total))
echo "Memory Usage: ${mem_usage}%"

# Get Disk Usage
# 'df' reports file system disk space usage. We check the root directory.
disk_usage=$(df -h / | grep / | awk '{print $5}' | sed 's/%//g')
echo "Disk Usage: ${disk_usage}%"

echo "----------------------"