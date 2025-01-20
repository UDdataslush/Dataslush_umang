#!/bin/bash

# Define the data file name for testing (optional, change if needed)
Data_csv="sales_data_sample.csv"

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

# Initialize the data quality report
> "$REPORT_FILE"
echo "Data Quality Report - $(date)" >> "$REPORT_FILE"
echo "------------------------------------" >> "$REPORT_FILE"

# Check if there are any CSV files to process
CSV_FILES=("$SOURCE_DIR"/*.csv)
if [[ ! -e "${CSV_FILES[0]}" ]]; then
    echo "No CSV files found in $SOURCE_DIR. Exiting." | tee -a "$REPORT_FILE"
    exit 1
fi

# Backup and process each CSV file
for file in "$SOURCE_DIR"/*.csv; do
    if [[ -f $file ]]; then
        BASENAME=$(basename "$file")
        echo "Processing file: $file"

        # Backup the file with a timestamp
        BACKUP_FILE="$BACKUP_DIR/${BASENAME%.csv}_$TIMESTAMP.csv"
        if cp "$file" "$BACKUP_FILE"; then
            echo "Backed up $file to $BACKUP_FILE"
        else
            echo "Error backing up $file" >&2
            continue
        fi

        # Data Wrangling: Remove empty rows, sort, and deduplicate
        WRANGLED_FILE="$WRANGLED_DIR/${BASENAME%.csv}_cleaned_$TIMESTAMP.csv"
        if awk 'BEGIN {FS=","; OFS=","} NF>1 {print}' "$file" | sort | uniq > "$WRANGLED_FILE"; then
            echo "Wrangled data saved to $WRANGLED_FILE"
        else
            echo "Error wrangling $file" >&2
            continue
        fi

        # Add quality checks to the report
        echo "Processing $WRANGLED_FILE for quality check" >> "$REPORT_FILE"

        # Row count
        ROW_COUNT=$(wc -l < "$WRANGLED_FILE")
        echo "Row Count: $ROW_COUNT" >> "$REPORT_FILE"

        # Check for 'Sales' column and calculate total sales
        if head -n 1 "$WRANGLED_FILE" | grep -qi "Sales"; then
            TOTAL_SALES=$(awk -F, 'NR>1 {sum+=$NF} END {print sum}' "$WRANGLED_FILE")
            echo "Total Sales: $TOTAL_SALES" >> "$REPORT_FILE"
        else
            echo "Sales column not found." >> "$REPORT_FILE"
        fi

        echo "------------------------------------" >> "$REPORT_FILE"
    else
        echo "No valid CSV files found in $SOURCE_DIR." | tee -a "$REPORT_FILE"
    fi
done

# Final message
echo "Backup, data wrangling, and quality check completed. Report saved to $REPORT_FILE."
