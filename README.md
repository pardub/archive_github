# Github archive project
## Problem Description
This project revolves around tracking and analyzing events occurring within GitHub. By examining these events, valuable insights into open-source development and community dynamics can be gained, for e.g, identify the repository with the highest number of commits, analyze the distribution of events by type or determine the user with the highest number of commits.

The goals are:

- Establish a batch pipeline to process the dataset and store it in a data lake.
- Develop a batch pipeline to transfer the data from the data lake to a data warehouse.
- Perform data transformation within the data warehouse to prepare it for dashboard integration.
- Construct a dashboard using Data Studio to visualize the prepared data.

## Development Environment

  - Cloud Provider: Google Cloud Platform (GCP)
  - Infrastructure Automation: Terraform for Infrastructure as Code (IaC)
  - Workflow Management: Prefect for orchestration
  - Data Storage: BigQuery for Data Warehousing
  - Data Lake Storage: Google Cloud Storage
  - Batch Processing and Transformations: Utilizing dbt cloud and Spark
  - Dashboard Creation: Google Data Looker Studio
    
## Architecture of the Project

  - Data is fetched in batches and then stored in Google Cloud Storage.
  - Following this, the data undergoes preprocessing using PySpark before being migrated to a Data Warehouse, specifically BigQuery.
  - Once in the Data Warehouse, the data undergoes transformation and preparation to make it suitable for visualization purposes.
  - Finally, dashboards are created to present the processed data effectively.
