#!/bin/bash

export LC_NUMERIC=C

cpu_line=$(top -b -n1 | grep "^%Cpu(s)")
user_usage=$(echo "$cpu_line" | awk '{print $2}')
system_usage=$(echo "$cpu_line" | awk '{print $4}')
total=$(echo "$user_usage" + "$system_usage" | bc)

echo "Total CPU usage: $total%"

total_mem=$(free -b | awk '/^Mem:/ {print $2}')
used_mem=$(free -b | awk '/^Mem:/ {print $3}')
free_mem=$(free -b | awk '/^Mem:/ {print $4}')

used_percent_mem=$(echo "scale=1; $used_mem / $total_mem * 100" | bc)
echo "Used memory:  $used_percent_mem%"

free_percent_mem=$(echo "scale=1; $free_mem / $total_mem * 100" | bc)
echo "free memory: $free_percent_mem%"

disk_usage=$(df | grep "/dev" | awk '{print $5}')
disk_availible_GB=$(df -h | grep "/dev" | awk '{print $4}')
echo "total disk usage: $disk_usage ($disk_availible_GB availible)"

top5_processes_cpu=$(ps -eo pid,comm,%cpu --sort=-%cpu | sed 1d | head -n 5)
echo "Top 5 processes by CPU usage"
echo "$top5_processes_cpu"

top5_processes_mem=$(ps -eo pid,comm,%mem --sort=-%mem | sed 1d | head -n 5)
echo "Top 5 processes by memory usage"
echo "$top5_processes_mem"

