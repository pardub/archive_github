# Github archive project
## Problem Description
This project revolves around tracking and analyzing events occurring within GitHub. By examining these events, valuable insights into open-source development and community dynamics can be gained, for e.g, identify the repository with the highest number of commits, analyze the distribution of events by type or determine the user with the highest number of commits.

The goals are:

- Establish a batch pipeline to process the dataset and store it in a data lake.
- Develop a batch pipeline to transfer the data from the data lake to a data warehouse.
- Perform data transformation within the data warehouse to prepare it for dashboard integration.
- Construct a dashboard using Data Studio to visualize the prepared data.

## Technologies

  - Cloud: GCP
  - Infrastructure as code (IaC): Terraform
  - Workflow orchestration: Prefect
  - Data Warehouse: BigQuery
  - Data Lake: Google Cloud Storage
  - Batch processing/Transformations: dbt cloud and Spark
  - Dashboard: Google Data Looker Studio
