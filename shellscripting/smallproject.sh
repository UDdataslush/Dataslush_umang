#!/bin/bash

# Base directory (same as script's location)
BASE_DIR="$(dirname "$0")"
SOURCE_DIR="$BASE_DIR/daily_sales"
BACKUP_DIR="$BASE_DIR/backup_sales"
WRANGLED_DIR="$BASE_DIR/wrangled_data"
REPORT_FILE="$BASE_DIR/data_quality_report.txt"

# Ensure necessary directories exist
mkdir -p "$SOURCE_DIR"
mkdir -p "$BACKUP_DIR"
mkdir -p "$WRANGLED_DIR"
# Get current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup CSV files
for file in "$SOURCE_DIR"/*.csv; do
    if [[ -f $file ]]; then
        BASENAME=$(basename "$file")
        BACKUP_FILE="$BACKUP_DIR/${BASENAME%.csv}_$TIMESTAMP.csv"
        cp "$file" "$BACKUP_FILE"
        echo "Backed up $file to $BACKUP_FILE"

        # Data Wrangling
        WRANGLED_FILE="$WRANGLED_DIR/${BASENAME%.csv}_cleaned_$TIMESTAMP.csv"
        awk 'BEGIN {FS=","; OFS=","} NF>1 {print}' "$file" | \
        sort | uniq > "$WRANGLED_FILE"
        echo "Wrangled data saved to $WRANGLED_FILE"
    fi
done
# Data Quality Check
> "$REPORT_FILE" # Clear or create the report file
echo "Data Quality Report - $(date)" >> "$REPORT_FILE"
echo "------------------------------------" >> "$REPORT_FILE"
for file in "$WRANGLED_DIR"/*.csv; do
    if [[ -f $file ]]; then
        echo "Processing $file" >> "$REPORT_FILE"
        # Row count
        ROW_COUNT=$(wc -l < "$file")
        echo "Row Count: $ROW_COUNT" >> "$REPORT_FILE"
        # Extract key metrics (example: total sales, if a 'Sales' column exists)
        if head -n 1 "$file" | grep -qi "Sales"; then
            TOTAL_SALES=$(awk -F, 'NR>1 {sum+=$NF} END {print sum}' "$file")
            echo "Total Sales: $TOTAL_SALES" >> "$REPORT_FILE"
        else
            echo "Sales column not found." >> "$REPORT_FILE"
        fi
        echo "------------------------------------" >> "$REPORT_FILE"
    fi
done
echo "Backup, data wrangling, and quality check completed. Report saved to $REPORT_FILE."



