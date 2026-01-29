# OPNsense-node-exporter-smartctl-collect

This repo contains a shell script and a `configd` action to collect SMART data from an NVMe drive and expose them to Prometheus via the Node Exporter plugin and textfile collector on an OPNsense router.

## Required OPNsense Plugins

*   **os-node_exporter** To collect and expose metrics to Prometheus
*   **os-smart** Required for `smartctl`

## Files

*   `smart-metrics.sh`: The data collection script. It runs `smartctl`, parses the output, and writes a `.prom` file to the Node Exporter textfile directory.
*   `actions_smartmetrics.conf`: Configuration file allowing the script to be triggered via OPNsense's `configd` system (and thus the Cron scheduler).

## Installation

1.  **Copy the script**:
    Upload `smart-metrics.sh` to your OPNsense device, place it in `/usr/local/bin/`, and make it executable with `chmod +x /usr/local/bin/smart-metrics.sh`

    *Note: The script is currently hardcoded for an NVME drive at `/dev/nvme0`*

2.  **Copy the action configuration**:
    Upload `actions_smartmetrics.conf` to `/usr/local/opnsense/service/conf/actions.d/`.

3.  **Reload configd**:
    To register the new action, restart the config daemon with `service configd restart`


## Usage & Automation

### Manual Test

You can test if the action is registered correctly by running `configctl smartmetrics collect`

This should generate the file at `/var/tmp/node_exporter/smart_metrics.prom`


### Setup Cron Job

To collect metrics on a schedule:

1.  Go to **System > Settings > Cron**.
2.  Click the **+** button to add a new job.
3.  **Command**: Select `Collect SMART Metrics for Node Exporter` from the dropdown.
4.  **Schedule**: Set your interval, I use every 30 minutes.
5.  Click **Save**.

## Exposed Metrics

The following metrics are exported and can be found in Prometheus. I use Grafana to visualize them.

*   `node_disk_smart_data_units_written_total`: Total data units written to the NVMe drive.
*   `node_disk_smart_power_on_hours_total`: Total power-on hours.
*   `node_disk_smart_temperature_celsius`: Current drive temperature.

