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

# Extract values from nvme0
WRITTEN=$(/usr/local/sbin/smartctl -a /dev/nvme0 | grep "Data Units Written" | awk '{print $4}' | tr -d ',')
HOURS=$(/usr/local/sbin/smartctl -a /dev/nvme0 | grep "Power On Hours" | awk '{print $4}' | tr -d ',')
TEMP=$(/usr/local/sbin/smartctl -a /dev/nvme0 | grep "Temperature:" | awk '{print $2}')

# Output to Prometheus format
cat << EOF > "$OUT_FILE.tmp"
# HELP node_disk_smart_data_units_written_total Total data units written to NVMe.
# TYPE node_disk_smart_data_units_written_total counter
node_disk_smart_data_units_written_total{device="nvme0"} $WRITTEN
# HELP node_disk_smart_power_on_hours_total Total power on hours.
# TYPE node_disk_smart_power_on_hours_total counter
node_disk_smart_power_on_hours_total{device="nvme0"} $HOURS
# HELP node_disk_smart_temperature_celsius Current drive temperature.
# TYPE node_disk_smart_temperature_celsius gauge
node_disk_smart_temperature_celsius{device="nvme0"} $TEMP
EOF

mv "$OUT_FILE.tmp" "$OUT_FILE"