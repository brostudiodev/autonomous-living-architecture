---
title: "S01.01: Goals Dashboard Monitoring"
type: "system_spec"
status: "active"
system_id: "S01.01"
owner: "Michał"
updated: "2026-02-07"
---

# S01.01: Goals Dashboard Monitoring

## Purpose
This system provides real-time observability for personal goals and tasks defined in `EXECUTION.md` files, visualized through a Grafana dashboard.

## Architecture
The Goals Dashboard Monitoring system is comprised of three core components orchestrated via Docker Compose:

1.  **Goals Exporter**: A Python application that parses `EXECUTION.md` files to extract task-related metrics (e.g., total tasks, completed tasks, priorities) and exposes them in Prometheus format, and also provides a JSON API for goal details.
    *   **Location**: `/home/michal/Documents/autonomous-living/infrastructure/scripts/goals-exporter.py`
    *   **Dockerfile**: `/home/michal/Documents/autonomous-living/infrastructure/scripts/Dockerfile.exporter`
    *   **Internal Port**: `8080` (within its Docker container)
    *   **Host Port**: `8082` (mapped from `8080` for Prometheus scraping and direct JSON API access)

2.  **Prometheus**: A monitoring system that scrapes metrics from the Goals Exporter at regular intervals.
    *   **Location**: Managed via `docker-compose.yml`
    *   **Configuration**: `/home/michal/Documents/autonomous-living/infrastructure/prometheus/prometheus.yml`
    *   **UI Port**: `9090` (on host)

3.  **Grafana**: A visualization tool that queries Prometheus for aggregated goal metrics and uses a JSON API data source to display detailed task lists.
    *   **Location**: Managed via `docker-compose.yml`
    *   **Dashboard Definition**: `/home/michal/Documents/autonomous-living/infrastructure/grafana/dashboards/goals-dashboard.json`
    *   **UI Port**: `3003` (on host)

## Data Flow
1.  **Task Definition**: Goals and tasks are defined in `EXECUTION.md` files located in subdirectories under `/home/michal/Documents/autonomous-living/docs/10_GOALS/`.
2.  **Metric Generation**: The `goals-exporter.py` script, running in a Docker container, reads these `EXECUTION.md` files (mounted as `/docs` inside the container). It parses the task information using regular expressions and generates:
    *   Prometheus-compatible metrics, exposed on `/metrics`.
    *   A JSON API endpoint at `/goals` returning all goal details.
    *   Individual goal JSON API endpoints at `/goals/<GOAL_ID>` returning details for a specific goal.
3.  **Metric Scrapping**: The Prometheus container, part of the same Docker Compose network, is configured to scrape metrics from the `goals-exporter` service (referencing it by its service name `goals-exporter` on port `8080`).
4.  **Visualization**: Grafana, also in the same Docker Compose network, connects to:
    *   **Prometheus** as a data source for overall progress, task priority breakdowns, and goal completion rates.
    *   **GoalsJSON (marcusolsson-json-datasource)** as a data source for detailed incomplete task lists, querying the `goals-exporter`'s `/goals` endpoint and processing the data using JavaScript within the dashboard panels.

## Recent Changes & Troubleshooting Summary (as of 2026-01-27)

This section summarizes recent modifications and debugging efforts to resolve display issues on the "Autonomous Living - Goals Dashboard."

### Grafana Configuration Updates
*   **JSON API Plugin**: The `docker-compose.yml` was updated to ensure the `marcusolsson-json-datasource` plugin is installed (replacing `grafana-simple-json-datasource`).
*   **`GoalsJSON` Data Source**: The provisioning file (`/home/michal/grafana/provisioning/datasources/goals-json.yml`) was updated to correctly set `type: marcusolsson-json-datasource`.

### Dashboard (`goals-dashboard.json`) Updates
*   **`jsonPath` Transformation Removal**: Problematic `jsonPath` transformations, which caused "jsonPath not found" errors, were removed from panels 6-17.
*   **JavaScript Data Processing**: Panels 6-17 ("Incomplete Tasks") were reconfigured to use the JavaScript `data` field of the `marcusolsson-json-datasource`. These panels now query the base `/goals` endpoint of the `goals-exporter` (which returns all goals) and use JavaScript to filter the response based on the `$goal` template variable.
*   **Templating Variable (`$goal`)**: The `definition` for the `goal` template variable was updated to `$.keys()` to correctly extract goal IDs from the `goals-exporter`'s JSON response, ensuring proper population of the variable dropdown.
*   **JSON Escaping**: Resolved issues with invalid JSON character escaping (`\n`) in JavaScript code within dashboard JSON, which previously prevented the dashboard from loading.

### Debugging & System Cleanup
*   **Grafana Data Cleanup**: Grafana's internal data directory (`/home/michal/grafana/data`) was cleared to remove any cached dashboard definitions or database inconsistencies.
*   **Docker Process Cleanup**: Addressed "port is already allocated" errors by manually identifying and terminating orphaned `docker-proxy` processes and restarting the Docker daemon, ensuring clean port binding.

## Current Status (as of 2026-01-27)

*   The dashboard structure loads correctly.
*   Queries to both Prometheus and the GoalsJSON data source are successfully retrieving data (HTTP 200 OK).
*   Prometheus-fed panels (`Tasks by Priority`, etc.) are now expected to display data.
*   GoalsJSON-fed panels (`Incomplete Tasks` for each goal) are still showing "NO DATA". This indicates an issue with either:
    *   The `$goal` template variable not being correctly populated in the UI, or its value not matching the JSON keys.
    *   An error in the JavaScript execution within the `marcusolsson-json-datasource` after receiving the response, preventing data from being formatted for the table panel.
    *   A display incompatibility with the simplified data format (returning only 'Task Name') for the table panel.

## Next Debugging Steps

To resolve the "NO DATA" issue for the "Incomplete Tasks" panels, the following information is critical:

1.  **Value of `$goal` template variable**: What is selected in the "goal" dropdown at the top of the dashboard?
2.  **"Inspect -> Data" tab content**: For *one* problematic "Incomplete Tasks" panel, provide the full content of the "Inspect -> Data" tab (showing the final data output after JavaScript processing).
3.  **Browser Developer Console (F12)**: Check the "Console" and "Network" tabs for any errors when loading the dashboard or interacting with panels.

## Setup/Restart Procedure (Updated)

To ensure the entire Goals Dashboard Monitoring stack is running with the latest configurations and a clean state:

1.  **Navigate to the Grafana directory**:
    ```bash
    cd /home/michal/grafana
    ```
2.  **Bring down the existing stack forcefully**:
    ```bash
    docker-compose down
    ```
3.  **Remove any lingering Docker processes holding ports (if errors occur during startup)**:
    ```bash
    # Check for processes on port 9090 (Prometheus)
    sudo lsof -i :9090
    # Check for processes on port 8082 (Goals Exporter)
    sudo lsof -i :8082
    # If PIDs are found, kill them (replace PIDs with actual process IDs)
    # sudo kill -9 <PID1> <PID2> ...
    ```
4.  **Clear Grafana's internal data (important for fresh provisioning)**:
    ```bash
    sudo rm -rf ./data/*
    ```
5.  **Bring up the entire stack, rebuilding images**:
    ```bash
    docker-compose up -d --build
    ```

## Verification Steps (Updated)

1.  **Check Goals Exporter JSON API**:
    ```bash
    curl http://localhost:8082/goals
    ```
    Verify that it returns a JSON object containing all goals.
2.  **Check Prometheus Targets**:
    *   Open `http://localhost:9090` in your browser.
    *   Navigate to **Status** -> **Targets**.
    *   Ensure the `goals-tracker` target is `UP`.
3.  **Check Grafana Dashboard**:
    *   Open `http://localhost:3003` in your browser.
    *   Perform a **hard refresh** (`Ctrl+Shift+R` or `Cmd+Shift+R`).
    *   Navigate to the "Autonomous Living - Goals Dashboard".
    *   Confirm that data is displayed in all panels.
    *   If "NO DATA" persists, use the **Next Debugging Steps** above.