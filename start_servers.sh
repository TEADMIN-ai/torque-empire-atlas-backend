#!/bin/bash
set -euo pipefail

log_message() {
  echo "[ $(date) ] $1"
}

log_message "âœ… Starting Plumber API..."

Rscript docker/run_api.R
