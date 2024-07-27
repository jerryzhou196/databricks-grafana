# Monitor Databricks Spark Metrics On Grafana  
  
- 🔥 Real-time plug and play functionality with one-click `init script` deployment.

- 💸 Persist Databricks Spark metrics to properly provision `instance-types` across AWS, GCP and Azure. This can save enterprise Databricks customers thousands in monthly compute cost.

- 🔧 Fine-tune Spark jobs and identify Spark worst-practices. 

- 🦾 [Terraformatically](https://docs.databricks.com/en/dev-tools/terraform/index.html) deploy using [Databricks Cluster Policies](https://docs.databricks.com/en/init-scripts/index.html) 

- 😌 Leverage Grafana Mimir Cloud's pricing model ($8/month for 1k series, which is **far cheaper** than other vendors like DataDog).

# Why monitor and alert?
A robust monitoring and alerting system lets DevOps and engineering teams proactively answer the following questions to help maintain a healthy and stable production environment:

1) **Health check:** Are your jobs and your core/golden signals healthy?

2) **Real-time alerting:** Is something broken or about to be broken?

3) **Ad hoc retrospective analysis**: “Our jobs ran really slow last night; what happened around the same time?”

4) **Experiment configurations**: “Were my jobs running slower last week? Should we add more CPU or memory to improve performance?”

# Why Use This Over Other Solutions? 

Currently, no **cloud-agnostic** single-source-of-truth for Databricks Spark Monitoring exists. Native solutions like Ganglia UI and [Databricks Compute Metrics](https://docs.databricks.com/en/compute/cluster-metrics.html) exist. Here are some problems with the existing solutions: 

- Ganglia doesn't support alerts, custom metric visualizations or long-term persistance.

- [Existing solutions like this one using AWS's cloudwatch agents](https://aws.amazon.com/blogs/mt/how-to-monitor-databricks-with-amazon-cloudwatch/) are extremely buggy and not well-maintained. This solution leverages the open-source Open-Telemetry Collector that guranteeds fast performance and much more robustness. 
