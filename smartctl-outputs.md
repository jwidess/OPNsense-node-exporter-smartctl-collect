# smartctl-outputs.md

This file is for collecting samples of smartctl outputs from various drives to improve `smart-metrics.sh`.

If you have a drive that doesn't work properly with the current script, please run the following command and share the output by opening an issue or a PR with a new section below named after your drive. **NOTE**: Please redact your serial number from the output before sharing.

Command to run (replace `/dev/nvme0` with your drive path):
```sh
smartctl -j -a /dev/nvme0
```

## NVMe Drives:

### TEAMGROUP MP33 256GB (TM8FP6256G) - 1/30/2025
```sh
{
  "json_format_version": [
    1,
    0
  ],
  "smartctl": {
    "version": [
      7,
      5
    ],
    "pre_release": false,
    "svn_revision": "5714",
    "platform_info": "FreeBSD 14.3-RELEASE-p7 amd64",
    "build_info": "(local build)",
    "argv": [
      "smartctl",
      "-j",
      "-a",
      "/dev/nvme0"
    ],
    "exit_status": 0
  },
  "local_time": {
    "time_t": 1769786601,
    "asctime": "Fri Jan 30 09:23:21 2026 CST"
  },
  "device": {
    "name": "/dev/nvme0",
    "info_name": "/dev/nvme0",
    "type": "nvme",
    "protocol": "NVMe"
  },
  "model_name": "TEAM TM8FP6256G",
  "serial_number": "<REDACTED>",
  "firmware_version": "VC3S500J",
  "nvme_pci_vendor": {
    "id": 4332,
    "subsystem_id": 4332
  },
  "nvme_ieee_oui_identifier": 57420,
  "nvme_controller_id": 1,
  "nvme_version": {
    "string": "1.4",
    "value": 66560
  },
  "nvme_number_of_namespaces": 1,
  "nvme_namespaces": [
    {
      "id": 1,
      "size": {
        "blocks": 500118192,
        "bytes": 256060514304
      },
      "capacity": {
        "blocks": 500118192,
        "bytes": 256060514304
      },
      "utilization": {
        "blocks": 500118192,
        "bytes": 256060514304
      },
      "formatted_lba_size": 512,
      "eui64": {
        "oui": 57420,
        "ext_id": 413360850435
      },
      "features": {
        "value": 0,
        "thin_provisioning": false,
        "na_fields": false,
        "dealloc_or_unwritten_block_error": false,
        "uid_reuse": false,
        "np_fields": false,
        "other": 0
      },
      "lba_formats": [
        {
          "formatted": true,
          "data_bytes": 512,
          "metadata_bytes": 0,
          "relative_performance": 0
        }
      ]
    }
  ],
  "user_capacity": {
    "blocks": 500118192,
    "bytes": 256060514304
  },
  "logical_block_size": 512,
  "smart_support": {
    "available": true,
    "enabled": true
  },
  "nvme_firmware_update_capabilities": {
    "value": 2,
    "slots": 1,
    "first_slot_is_read_only": false,
    "activiation_without_reset": false,
    "multiple_update_detection": false,
    "other": 0
  },
  "nvme_optional_admin_commands": {
    "value": 23,
    "security_send_receive": true,
    "format_nvm": true,
    "firmware_download": true,
    "namespace_management": false,
    "self_test": true,
    "directives": false,
    "mi_send_receive": false,
    "virtualization_management": false,
    "doorbell_buffer_config": false,
    "get_lba_status": false,
    "command_and_feature_lockdown": false,
    "other": 0
  },
  "nvme_optional_nvm_commands": {
    "value": 94,
    "compare": false,
    "write_uncorrectable": true,
    "dataset_management": true,
    "write_zeroes": true,
    "save_select_feature_nonzero": true,
    "reservations": false,
    "timestamp": true,
    "verify": false,
    "copy": false,
    "other": 0
  },
  "nvme_log_page_attributes": {
    "value": 2,
    "smart_health_per_namespace": false,
    "commands_effects_log": true,
    "extended_get_log_page_cmd": false,
    "telemetry_log": false,
    "persistent_event_log": false,
    "supported_log_pages_log": false,
    "telemetry_data_area_4": false,
    "other": 0
  },
  "nvme_maximum_data_transfer_pages": 32,
  "nvme_composite_temperature_threshold": {
    "warning": 100,
    "critical": 110
  },
  "temperature": {
    "op_limit_max": 100,
    "critical_limit_max": 110,
    "current": 54
  },
  "nvme_power_states": [
    {
      "non_operational_state": false,
      "relative_read_latency": 0,
      "relative_read_throughput": 0,
      "relative_write_latency": 0,
      "relative_write_throughput": 0,
      "entry_latency_us": 230000,
      "exit_latency_us": 50000,
      "max_power": {
        "value": 800,
        "scale": 2,
        "units_per_watt": 100
      }
    },
    {
      "non_operational_state": false,
      "relative_read_latency": 1,
      "relative_read_throughput": 1,
      "relative_write_latency": 1,
      "relative_write_throughput": 1,
      "entry_latency_us": 4000,
      "exit_latency_us": 50000,
      "max_power": {
        "value": 400,
        "scale": 2,
        "units_per_watt": 100
      }
    },
    {
      "non_operational_state": false,
      "relative_read_latency": 2,
      "relative_read_throughput": 2,
      "relative_write_latency": 2,
      "relative_write_throughput": 2,
      "entry_latency_us": 4000,
      "exit_latency_us": 250000,
      "max_power": {
        "value": 300,
        "scale": 2,
        "units_per_watt": 100
      }
    },
    {
      "non_operational_state": true,
      "relative_read_latency": 3,
      "relative_read_throughput": 3,
      "relative_write_latency": 3,
      "relative_write_throughput": 3,
      "entry_latency_us": 5000,
      "exit_latency_us": 10000,
      "max_power": {
        "value": 300,
        "scale": 1,
        "units_per_watt": 10000
      }
    },
    {
      "non_operational_state": true,
      "relative_read_latency": 4,
      "relative_read_throughput": 4,
      "relative_write_latency": 4,
      "relative_write_throughput": 4,
      "entry_latency_us": 54000,
      "exit_latency_us": 45000,
      "max_power": {
        "value": 50,
        "scale": 1,
        "units_per_watt": 10000
      }
    }
  ],
  "smart_status": {
    "passed": true,
    "nvme": {
      "value": 0
    }
  },
  "nvme_smart_health_information_log": {
    "nsid": -1,
    "critical_warning": 0,
    "temperature": 54,
    "available_spare": 100,
    "available_spare_threshold": 32,
    "percentage_used": 7,
    "data_units_read": 860662,
    "data_units_written": 25882809,
    "host_reads": 17210846,
    "host_writes": 226947275,
    "controller_busy_time": 0,
    "power_cycles": 51,
    "power_on_hours": 7420,
    "unsafe_shutdowns": 17,
    "media_errors": 0,
    "num_err_log_entries": 0,
    "warning_temp_time": 0,
    "critical_comp_time": 0
  },
  "spare_available": {
    "current_percent": 100,
    "threshold_percent": 32
  },
  "endurance_used": {
    "current_percent": 7
  },
  "power_cycle_count": 51,
  "power_on_time": {
    "hours": 7420
  },
  "nvme_error_information_log": {
    "size": 8,
    "read": 8,
    "unread": 0
  },
  "nvme_self_test_log": {
    "nsid": -1,
    "current_self_test_operation": {
      "value": 0,
      "string": "No self-test in progress"
    }
  }
}
```


## SATA Drives:
*(No samples yet. Please contribute if you have a SATA drive.)*