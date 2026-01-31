#!/bin/sh

# This script collects SMART metrics from an NVMe drive on an OPNsense router
# and outputs them in a format for Prometheus Node Exporter's textfile collector.
# This script should exist at: /usr/local/bin/smart-metrics.sh
# The os-smart plugin MUST be installed for this to work.
# https://github.com/jwidess/OPNsense-node-exporter-smartctl-collect

# Drive to monitor
export DEVICE="/dev/nvme0"

# Cron schedule interval in minutes (used by Grafana for Min interval)
# Update this to match your cron job schedule in the OPNsense web UI
export SCRAPE_INTERVAL_MINUTES=5

# Target file for Node Exporter to read
# The os-node_exporter plugin by default uses /var/tmp/node_exporter for textfile metrics
TEXTFILE_DIR="/var/tmp/node_exporter"
OUT_FILE="$TEXTFILE_DIR/smart_metrics.prom"

# ===============================================================

mkdir -p "$TEXTFILE_DIR"

#OPNsense by default ships with Python 3 at /usr/local/bin/python3
/usr/local/sbin/smartctl -j -a "$DEVICE" | /usr/local/bin/python3 -c '
import sys, json, os

device_path = os.environ.get("DEVICE", "/dev/nvme0")
device_name = os.path.basename(device_path)
scrape_interval = int(os.environ.get("SCRAPE_INTERVAL_MINUTES", 5))

# Output the scrape interval metric
print("# HELP node_disk_smart_scrape_interval_minutes Cron schedule interval in minutes for SMART metrics collection, update this value to match your cron job schedule in the OPNsense web UI")
print("# TYPE node_disk_smart_scrape_interval_minutes gauge")
print(f"node_disk_smart_scrape_interval_minutes {scrape_interval}")

try:
    data = json.load(sys.stdin)
    # NVMe devices store main stats in this object
    smart_log = data.get("nvme_smart_health_information_log", {})
    
    # metrics mapping: metric_name -> (value, help, type)
    metrics = {
        "node_disk_smart_critical_warning": (smart_log.get("critical_warning"), "Critical warning state (0 is good)", "gauge"),
        "node_disk_smart_temperature_celsius": (smart_log.get("temperature"), "Current drive temperature", "gauge"),
        "node_disk_smart_available_spare_percent": (smart_log.get("available_spare"), "Available spare capacity percentage", "gauge"),
        "node_disk_smart_available_spare_threshold_percent": (smart_log.get("available_spare_threshold"), "Available spare threshold percentage", "gauge"),
        "node_disk_smart_percentage_used_percent": (smart_log.get("percentage_used"), "Percentage of drive life used", "gauge"),
        "node_disk_smart_data_units_read_total": (smart_log.get("data_units_read"), "Total data units read (1000 units of 512 bytes)", "counter"),
        "node_disk_smart_data_units_written_total": (smart_log.get("data_units_written"), "Total data units written (1000 units of 512 bytes)", "counter"),
        "node_disk_smart_host_read_commands_total": (smart_log.get("host_reads"), "Total host read commands", "counter"),
        "node_disk_smart_host_write_commands_total": (smart_log.get("host_writes"), "Total host write commands", "counter"),
        "node_disk_smart_controller_busy_time_minutes_total": (smart_log.get("controller_busy_time"), "Controller busy time", "counter"),
        "node_disk_smart_power_cycles_total": (smart_log.get("power_cycles"), "Total power cycles", "counter"),
        "node_disk_smart_power_on_hours_total": (smart_log.get("power_on_hours"), "Total power on hours", "counter"),
        "node_disk_smart_unsafe_shutdowns_total": (smart_log.get("unsafe_shutdowns"), "Total unsafe shutdowns", "counter"),
        "node_disk_smart_media_errors_total": (smart_log.get("media_errors"), "Total media and data integrity errors", "counter"),
        "node_disk_smart_error_log_entries_total": (smart_log.get("num_err_log_entries"), "Total error log entries", "counter"),
        "node_disk_smart_warning_temp_time_minutes_total": (smart_log.get("warning_temp_time"), "Time in minutes the drive has been above warning temperature", "counter"),
        "node_disk_smart_critical_comp_time_minutes_total": (smart_log.get("critical_comp_time"), "Time in minutes the drive has been above critical temperature", "counter"),
    }

    print(f"# Processing device: {device_path}")
    for name, (value, help_text, metric_type) in metrics.items():
        if value is not None:
            print(f"# HELP {name} {help_text}")
            print(f"# TYPE {name} {metric_type}")
            print(f"{name}{{device=\"{device_name}\"}} {value}")

except Exception as e:
    # Output nothing on error to avoid corrupting the file
    sys.exit(1)
' > "$OUT_FILE.tmp"

if [ $? -eq 0 ]; then
    mv "$OUT_FILE.tmp" "$OUT_FILE"
else
    echo "Failed to collect SMART metrics" >&2
    rm -f "$OUT_FILE.tmp"
    exit 1
fi
