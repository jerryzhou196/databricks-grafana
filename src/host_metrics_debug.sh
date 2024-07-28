#!/bin/bash

set -euxo pipefail

initialize_env() {
  pwd
  export SPARK_LOCAL_IP=$(hostname -I | awk '{print $1}')
  printenv
  apt-get update
  apt install -y gettext
  mkdir -p /databricks/otelcol 
}

generate_config() {
	local config_path="/databricks/otelcol/config.yaml"
	cat <<EOF | envsubst >$config_path
extensions:
  basicauth/grafana_cloud:
    # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/basicauthextension
    client_auth:
      username: "\${GRAFANA_USERNAME}"
      password: "\${GRAFANA_CLOUD_KEY}"
receivers:
  hostmetrics:
    collection_interval: 10s
    scrapers:
      cpu:
      memory:
      disk:
      load:
        cpu_average: true
      filesystem:
      network:
      process:
      paging:
      processes:

  prometheus:
    config:
      scrape_configs:
        - job_name: "spark_metrics"
          scrape_interval: 10s
          metrics_path: "/metrics/prometheus"
          static_configs:
            - targets: ["\${SPARK_LOCAL_IP}:40001"]
        - job_name: "spark_exec_agg_metrics"
          scrape_interval: 10s
          metrics_path: "/metrics/executors/prometheus"
          static_configs:
            - targets: ["\${SPARK_LOCAL_IP}:40001"]

processors:
  batch:
    # https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor/batchprocessor
  resourcedetection:
    # Enriches telemetry data with resource information from the host
    # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/resourcedetectionprocessor
    detectors: ["env", "system"]
    override: false
  attributes:
    actions:
      - key: databricks_cluster_name
        value: \${DB_CLUSTER_NAME}
        action: insert
      - key: databricks_is_driver
        value: \${DB_IS_DRIVER}
        action: insert
  transform/add_resource_attributes_as_metric_attributes:
    # https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/transformprocessor
    error_mode: ignore
    metric_statements:
      - context: datapoint
        statements:
          - set(attributes["databricks_cluster_name"], resource.attributes["databricks_cluster_name"])
          - set(attributes["databricks_is_driver"], resource.attributes["databricks_is_driver"])

exporters:
  logging:
    loglevel: debug
  otlphttp/grafana_cloud:
    # https://github.com/open-telemetry/opentelemetry-collector/tree/main/exporter/otlpexporter
    endpoint: "\${GRAFANA_GATEWAY_URL}"
    auth:
      authenticator: basicauth/grafana_cloud

service:
  telemetry:
    logs:
      level: debug
  extensions: [basicauth/grafana_cloud]
  pipelines:
    metrics:
      receivers: [prometheus, hostmetrics]
      processors: [resourcedetection, attributes, transform/add_resource_attributes_as_metric_attributes]
      exporters: [otlphttp/grafana_cloud, logging]
EOF
}


setup_otelcol() {
  mkdir -p /databricks/otelcol/
  wget -P /databricks/otelcol https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.103.0/otelcol-contrib_0.103.0_linux_amd64.tar.gz
  tar -xzvf /databricks/otelcol/otelcol-contrib_0.103.0_linux_amd64.tar.gz -C /databricks/otelcol && chmod +x /databricks/otelcol/otelcol-contrib
	
  cat <<'EOT' | sudo tee /etc/systemd/system/databricks-otelcol.service
[Unit]
Description=Databricks OpenTelemetry Collector Service
After=network.target

[Service]
Type=simple
WorkingDirectory=/databricks/otelcol
ExecStart=/databricks/otelcol/otelcol-contrib --config /databricks/otelcol/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

  sudo systemctl daemon-reload
	sudo systemctl enable databricks-otelcol.service
	sudo systemctl start databricks-otelcol.service
}

# Function to initialize Spark Prometheus Servlet
init_spark_prometheus_servelet() {
	cat <<EOF >/databricks/spark/conf/metrics.properties
*.source.jvm.class=org.apache.spark.metrics.source.JvmSource
*.sink.prometheusServlet.class=org.apache.spark.metrics.sink.PrometheusServlet
*.sink.prometheusServlet.path=/metrics/prometheus
master.sink.prometheusServlet.path=/metrics/master/prometheus
applications.sink.prometheusServlet.path=/metrics/applications/prometheus
EOF
}

# Function to set Spark configurations
set_spark_confs() {
	local SPARK_DEFAULTS_CONF_PATH="/databricks/driver/conf/00-databricks-otel.conf"

	cat <<EOF >>$SPARK_DEFAULTS_CONF_PATH
"spark.executor.processTreeMetrics.enabled" = "true"
"spark.metrics.appStatusSource.enabled" = "true"
"spark.metrics.namespace" = ""
"spark.sql.streaming.metricsEnabled" = "true"
"spark.ui.prometheus.enabled" = "true"
EOF
}


initialize_env
generate_config
set_spark_confs
init_spark_prometheus_servelet
setup_otelcol
