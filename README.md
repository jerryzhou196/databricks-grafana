# Monitor Databricks Spark Metrics On Grafana  
  
- 🔥 Real-time plug and play functionality with one-click `init` script deployment.

- 💸 Persist Databricks Spark metrics to properly provision `instance-types` across AWS, GCP and Azure. This can save enterprise Databricks customers over thousands.

- 🔧 Fine-tune Spark jobs and identify Spark worst-practices. 

- 🦾 [Terraformatically](https://docs.databricks.com/en/dev-tools/terraform/index.html) deploy using [Databricks Cluster Policies](https://docs.databricks.com/en/init-scripts/index.html) 

- 😌 Leverage Grafana Mimir Cloud's pricing model ($8/month for 1k series, which is **far cheaper** than other vendors like DataDog).
 

# Why monitor and alert?
A robust monitoring and alerting system lets DevOps and engineering teams proactively answer the following questions to help maintain a healthy and stable production environment:

1) **Health check:** Are your jobs and your core/golden signals healthy?

2) **Real-time alerting:** Is something broken or about to be broken?

3) **Ad hoc retrospective analysis**: “Our jobs ran really slow last night; what happened around the same time?”

4) **Experiment configurations**: “Were my jobs running slower last week? Should we add more CPU or memory to improve performance?”

Core components in a Databricks monitoring and alerting system
1) **Metrics:** Metrics are numbers that describe activity or a particular process measured over a period of time. Here are different types of metrics on Databricks:

System resource-level metrics, such as CPU, memory, disk, and network.
Application Metrics using Custom Metrics Source, StreamingQueryListener, and QueryExecutionListener,
Spark Metrics exposed by MetricsSystem.

2) **Logs:** Logs are a representation of serial events that have happened, and they tell a linear story about them. Here are different types of logs on Databricks:
