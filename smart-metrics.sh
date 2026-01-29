#!/bin/sh

# This script collects SMART metrics from an NVMe drive and outputs them
# in a format for Prometheus Node Exporter's textfile collector.
# This script should exist at: /usr/local/bin/smart-metrics.sh
# The os-smart plugin MUST be installed for this to work.
# https://github.com/jwidess/OPNsense-node-exporter-smartctl-collect

# Target file for Node Exporter to read
# The os-node_exporter plugin by default uses /var/tmp/node_exporter for textfile metrics
TEXTFILE_DIR="/var/tmp/node_exporter"
OUT_FILE="$TEXTFILE_DIR/smart_metrics.prom"

mkdir -p "$TEXTFILE_DIR"

# Capture smartctl output
SMART_DATA=$(/usr/local/sbin/smartctl -a /dev/nvme0)

# Extract values from smartctl output
CRITICAL_HEX=$(echo "$SMART_DATA" | grep "Critical Warning:" | awk '{print $3}')
CRITICAL=$(printf "%d" "$CRITICAL_HEX")
TEMP=$(echo "$SMART_DATA" | grep "Temperature:" | awk '{print $2}')
SPARE=$(echo "$SMART_DATA" | grep "Available Spare:" | awk '{print $3}' | tr -d '%')
USED=$(echo "$SMART_DATA" | grep "Percentage Used:" | awk '{print $3}' | tr -d '%')
READ=$(echo "$SMART_DATA" | grep "Data Units Read" | awk '{print $4}' | tr -d ',')
WRITTEN=$(echo "$SMART_DATA" | grep "Data Units Written" | awk '{print $4}' | tr -d ',')
BUSY=$(echo "$SMART_DATA" | grep "Controller Busy Time" | awk '{print $4}' | tr -d ',')
CYCLES=$(echo "$SMART_DATA" | grep "Power Cycles" | awk '{print $3}' | tr -d ',')
HOURS=$(echo "$SMART_DATA" | grep "Power On Hours" | awk '{print $4}' | tr -d ',')
UNSAFE=$(echo "$SMART_DATA" | grep "Unsafe Shutdowns" | awk '{print $3}' | tr -d ',')
MEDIA_ERRORS=$(echo "$SMART_DATA" | grep "Media and Data Integrity Errors" | awk '{print $6}' | tr -d ',')
ERROR_LOG=$(echo "$SMART_DATA" | grep "Error Information Log Entries" | awk '{print $5}' | tr -d ',')

# Output to Prometheus format
cat << EOF > "$OUT_FILE.tmp"
# HELP node_disk_smart_critical_warning Critical warning state (0 is good).
# TYPE node_disk_smart_critical_warning gauge
node_disk_smart_critical_warning{device="nvme0"} $CRITICAL
# HELP node_disk_smart_temperature_celsius Current drive temperature.
# TYPE node_disk_smart_temperature_celsius gauge
node_disk_smart_temperature_celsius{device="nvme0"} $TEMP
# HELP node_disk_smart_available_spare_percent Available spare capacity percentage.
# TYPE node_disk_smart_available_spare_percent gauge
node_disk_smart_available_spare_percent{device="nvme0"} $SPARE
# HELP node_disk_smart_percentage_used_percent Percentage of drive life used.
# TYPE node_disk_smart_percentage_used_percent gauge
node_disk_smart_percentage_used_percent{device="nvme0"} $USED
# HELP node_disk_smart_data_units_read_total Total data units read.
# TYPE node_disk_smart_data_units_read_total counter
node_disk_smart_data_units_read_total{device="nvme0"} $READ
# HELP node_disk_smart_data_units_written_total Total data units written.
# TYPE node_disk_smart_data_units_written_total counter
node_disk_smart_data_units_written_total{device="nvme0"} $WRITTEN
# HELP node_disk_smart_controller_busy_time_minutes_total Controller busy time in minutes.
# TYPE node_disk_smart_controller_busy_time_minutes_total counter
node_disk_smart_controller_busy_time_minutes_total{device="nvme0"} $BUSY
# HELP node_disk_smart_power_cycles_total Total power cycles.
# TYPE node_disk_smart_power_cycles_total counter
node_disk_smart_power_cycles_total{device="nvme0"} $CYCLES
# HELP node_disk_smart_power_on_hours_total Total power on hours.
# TYPE node_disk_smart_power_on_hours_total counter
node_disk_smart_power_on_hours_total{device="nvme0"} $HOURS
# HELP node_disk_smart_unsafe_shutdowns_total Total unsafe shutdowns.
# TYPE node_disk_smart_unsafe_shutdowns_total counter
node_disk_smart_unsafe_shutdowns_total{device="nvme0"} $UNSAFE
# HELP node_disk_smart_media_errors_total Total media and data integrity errors.
# TYPE node_disk_smart_media_errors_total counter
node_disk_smart_media_errors_total{device="nvme0"} $MEDIA_ERRORS
# HELP node_disk_smart_error_log_entries_total Total error log entries.
# TYPE node_disk_smart_error_log_entries_total counter
node_disk_smart_error_log_entries_total{device="nvme0"} $ERROR_LOG
EOF

mv "$OUT_FILE.tmp" "$OUT_FILE"