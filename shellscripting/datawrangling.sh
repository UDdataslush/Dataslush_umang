#!/bin/bash

# Log file name
LOG_FILE="app.log"

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Error: Log file '$LOG_FILE' not found!"
  exit 1
fi

# Count the occurrences of "info" (case-insensitive) in the log file
echo "Counting 'INFO' occurrences (case-insensitive):"
grep -i -c info "$LOG_FILE"
echo

# Replace "INFO" with "LOG" in the first 10 lines, and stop at line 11
echo "Replacing 'INFO' with 'LOG' in the first 10 lines:"
sed '1,10s/INFO/LOG/g; 11q' "$LOG_FILE"
echo

# Print all lines containing "INFO"
echo "Lines containing 'INFO':"
sed -n '/INFO/p' "$LOG_FILE"
echo

# Print line numbers 2 to 10
echo "Printing line numbers 2 to 10:"
awk 'NR>=2 && NR<=10 {print NR}' "$LOG_FILE"
echo

# Display the first 10 lines of the log file
echo "First 10 lines of the log file:"
head "$LOG_FILE"
echo

# Print lines where the second field is between "08:53:00" and "08:53:59"
echo "Lines with timestamps between '08:53:00' and '08:53:59':"
awk '$2 >= "08:53:00" && $2 <= "08:53:59" {print $2, $3, $4}' "$LOG_FILE"
echo

# Print only the second field of the log file
echo "Second field of the log file:"
awk '{print $2}' "$LOG_FILE"
echo

# Count the number of lines containing "INFO"
echo "Counting lines with 'INFO':"
awk '/INFO/ {count++} END {print count}' "$LOG_FILE"
echo

# Print the first 5 fields of lines containing "INFO"
echo "Details of lines with 'INFO':"
awk '/INFO/ {print $1, $2, $3, $4, $5}' "$LOG_FILE"
echo

# Print the first two lines of the log file
echo "First two lines of the log file:"
head -n 2 "$LOG_FILE"
echo

# Print all lines of the log file
echo "Printing all lines of the log file:"
awk '{print}' "$LOG_FILE"
echo

# Print the last 5 lines of the log file
echo "Last 5 lines of the log file:"
tail -n 5 "$LOG_FILE"
echo

# Display unique IP addresses (assuming first field contains IPs)
echo "Unique IP addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq
echo

# Count the total number of lines in the log file
echo "Total number of lines in the log file:"
wc -l < "$LOG_FILE"
echo

