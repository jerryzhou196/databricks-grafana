# 🔎 Databricks Compute Metrics on Grafana

> "a single pane of glass" for cloud compute metrics

![image](https://github.com/user-attachments/assets/61801050-4955-4f3b-b106-eb3e3e9de89f)
  
- **one-click deployment** using Databricks init-scripts 

- robust design leveraging **blazing-fast** [open-source OTLP collector agents](https://github.com/open-telemetry/opentelemetry-collector)

- [terraformatically](https://docs.databricks.com/en/dev-tools/terraform/index.html) deploy across **hundreds** of clusters instantly using [Databricks Cluster Policies](https://docs.databricks.com/en/init-scripts/index.html) 

- leverage Grafana Cloud's **dirt-cheap** pricing model (approximately $8/cluster per month) 
  
# Why monitor and alert?

A robust monitoring and alerting system lets DevOps and engineering teams proactively answer the following questions to help maintain a healthy and stable production environment:

1) **Health check:** Are your jobs and your core/golden signals healthy?

2) **Real-time alerting:** Is something broken or about to be broken?

3) **Ad hoc retrospective analysis**: “Our jobs ran really slow last night; what happened around the same time?”

4) **Experiment configurations**: “Were my jobs running slower last week? Should we add more CPU or memory to improve performance?”

# Why use this over other solutions? 

Currently, no **cloud-agnostic** single-source-of-truth for Databricks Spark Monitoring exists. Native solutions like [Ganglia UI](https://medium.com/quintoandar-tech-blog/ganglia-on-spark-cluster-optimization-at-its-best-e5c9dc29253b) and [Databricks Compute Metrics](https://docs.databricks.com/en/compute/cluster-metrics.html) exist, but...

- Ganglia UI doesn't support alerts, custom metric visualizations or long-term persistance.

- Existing solutions [like this one using AWS's cloudwatch agents](https://aws.amazon.com/blogs/mt/how-to-monitor-databricks-with-amazon-cloudwatch/) are extremely buggy and not well-maintained as they rely on closed-source custom agents. This solution leverages the **Open-Source** [Open-Telemetry Collector](https://github.com/open-telemetry/opentelemetry-collector-contrib) that guranteeds lightning-fast performance and much more robustness.

- Databricks offers some [compute metrics](https://docs.databricks.com/en/compute/cluster-metrics.html) but these are bulky, not-persisted and hidden by cluster. These metrics are intentionally designed to be difficult to use out of an incentive to transition customers towards Databrick's Serverless Compute

