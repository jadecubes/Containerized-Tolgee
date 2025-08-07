#!/bin/bash

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script's directory
cd "$SCRIPT_DIR" || {
    echo "Error: Cannot change to $SCRIPT_DIR."
    exit 1
}

# Define path constants
LOKI_DIR="./loki"
GRAFANA_DATA_DIR="./grafana/data"
GRAFANA_PROVISIONING_DIR="./grafana/provisioning"
DATASOURCES_DIR="$GRAFANA_PROVISIONING_DIR/datasources"
DATASOURCE_YML="$DATASOURCES_DIR/datasource.yml"
NOTIFIERS_YML="$GRAFANA_PROVISIONING_DIR/notifiers/notifiers.yml"
ALERT_RULES_YML="$GRAFANA_PROVISIONING_DIR/alerting/alert-rules.yml"

echo "Setting up directories and permissions..."
mkdir -p "$LOKI_DIR" "$GRAFANA_DATA_DIR" "$DATASOURCES_DIR"
chown -R 472:472 "$GRAFANA_DATA_DIR"
chmod -R 700 "$GRAFANA_DATA_DIR"
chmod -R 755 "$GRAFANA_PROVISIONING_DIR"
echo "Checking for required YAML files..."
for file in "$DATASOURCE_YML" "$NOTIFIERS_YML" "$ALERT_RULES_YML"; do
    if [ ! -f "$file" ]; then
        echo "Error: $file does not exist. Please create it manually."
        exit 1
    fi
done
echo "Starting containers..."
if ! docker compose up -d; then
    echo "Error: Failed to start containers."
    exit 1
fi