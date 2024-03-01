# Github Archive project
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
  - Workflow Management: Airflow for orchestration (Airflow has been chosen over Mage as it is currently the most widely used in the industry, and I believe it's a good idea to practice it).
  - Data Storage: BigQuery for Data Warehousing
  - Data Lake Storage: Google Cloud Storage
  - Batch Processing and Transformations: Utilizing dbt cloud.
  - Dashboard Creation: Google Data Looker Studio
    
## Architecture of the Project

  - Data is fetched in batches and then stored in Google Cloud Storage.
  - Following this, the data undergoes preprocessing using Airflow before being migrated to a Data Warehouse, specifically BigQuery.
  - Once in the Data Warehouse, the data undergoes transformation and preparation with Dbt to make it suitable for visualization purposes.
  - Finally, dashboards are created to present the processed data effectively.
    
![picture_project_infrastructure](https://github.com/pardub/archive_github/assets/42610272/d9aca2f0-6596-4da2-8e1e-4917f8b3fc43)

### Dashboard
![Looker_final_project](https://github.com/pardub/archive_github/assets/42610272/15106599-d017-4fe8-a74f-99d7b8f29225)

# Setup

To replicate the project, you'll need the following :

- A Google Cloud Platform (GCP) account.
- (Optional) The Google Cloud SDK for streamlined installation and management.
- (Optional) An SSH client for terminal access.
- (Optional) VSCode with the Remote-SSH extension for convenient port forwarding.
- The development and testing phase utilized a Google Cloud Compute VM instance. It's highly recommended to employ a VM instance for reproducing the project.

# Generate a Google Cloud Project
- Navigate to the Google Cloud dashboard and initiate the creation of a new project by selecting it from the dropdown menu positioned at the top left corner of the screen, adjacent to the Google Cloud Platform label.
- Upon project creation, proceed to establish a Service Account with the specified roles:

    * BigQuery Admin
    * Storage Admin
    * Storage Object Admin
    * Viewer
      
Download the credentials file for the Service Account and rename it to `google_credentials.json`. Store this file in your home folder at `$HOME/.google/credentials/`.

Note: If you're utilizing a VM as advised, ensure to upload this credentials file to the VM.

Activate the following APIs:

- IAM API: https://console.cloud.google.com/apis/library/iam.googleapis.com
- IAM Credentials API: https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com

## Establishing an environment variable for the credentials

- Set up an environment variable named `GOOGLE_APPLICATION_CREDENTIALS` and allocate it the pathway to your JSON credentials file, typically located at `$HOME/.google/credentials/`.

- Run this command that will append the export statement to the `.bashrc` file in your home directory. Make sure to replace `<path/to/authkeys>.json` with the actual path to your JSON credentials file.

```sh
echo 'export GOOGLE_APPLICATION_CREDENTIALS="<path/to/authkeys>.json"' >> ~/.bashrc
```

- Please logout and then log back into your current terminal session, or execute the command source ~/.bashrc to enable the environment variable.

- Afterward, refresh the token and confirm authentication using the GCP SDK.

```sh 
gcloud auth application-default login
```

## Setting up Google Cloud SDK :

- Download the Google Cloud SDK from the provided link and install it based on your operating system's instructions.
- Initiate the SDK by executing `gcloud init` in a terminal and adhere to the instructions provided.
- Confirm that your project is selected by running `gcloud config list`.

## Creating a virtual machine (VM) on Google Cloud Platform (GCP) 
- The following command will create a VM using  the SDK.
- Change the virtual machine's name to one of your preference and select a zone that suits your requirements.

```sh
gcloud compute instances create vm1 --zone=us-central1-a --image=ubuntu-2004-focal-v20240209 --image-project=ubuntu-os-cloud --machine-type=e2-standard-4 --boot-disk-size=30GB
```

## Establish SSH connectivity to the VM
- Launch your instance through the VM instances dashboard on Google Cloud Platform.
- Ensure that the gcloud SDK is configured for your project in your local terminal. Use `gcloud config list` to view your current configuration details.
- If the current config doesn't match the desired account:
  - Utilize `gcloud config configurations list` to see available configurations and their associated accounts.
  - Switch to the desired config using `gcloud config configurations activate <my-project-name>
- Set up the SSH connection to your VM instances with `gcloud compute config-ssh`
  - A new `config file` should appear inside `~/ssh/` with the necessary connection information.
  - In the event that you do not possess an SSH key, a pair of public and private SSH keys will be created on your behalf.
  - This command will provide the hostname of your instance in the format: `instance.zone.project`. Make sure to note it down.
- You can now open a terminal and use SSH to connect to your VM instance using this command: `ssh instance.zone.project`
  
## Initiating and halting your instance using the gcloud SDK
- Starting your instance:
```sh
gcloud compute instances list
```
- Stopping the instance:
- ```sh
  gcloud compute instances stop <my_instance>
  ```
## Setting up the necessary tools on the virtual machine
- connect to your vm by ssh.
- Install Docker :
  ```sh
  sudo apt update && sudo apt -y upgrade
  ```
  ```sh
  run sudo sudo groupadd docker
   ```
   ```sh
  sudo gpasswd -a $USER docker
  ```
   ```sh
  sudo service docker restart
  ```
- test with docker by doing `run hello-world` to make sure Docker is correctly installed  on your vm.
 - Install Docker Compose :
    - Create a folder bin in your home account with `mkdir ~/bin`
    - Go to the folder with `cd ~/bin`
    - Download Docker Compose
    ```sh
    wget https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 -O docker-compose
    ```
      -  Make doker compose file executable with ```sh chmod +x docker-compose```
      - run this command echo `'export PATH="${HOME}/bin:${PATH}"' >> ~/.bashrc`  to update your path environment variable: 
 
Logout from your session and login again or run  `source .bashrc` to reload the path environment variable

## Terraform
- Installation:
  
```sh
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```
```sh
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```
```sh
sudo apt-get update && sudo apt-get install terraform
```
## Establish the project's infrastructure using Terraform

Clone this projet in your vm
```sh
git clone https://github.com/pardub/archive_github.git
```
Go to `archive_github/terraform/`

Run:
```sh
terraform init
```
```sh
terraform plan
```

```sh
terraform apply
```

Now, ensure that you've successfully set up a bucket named "data_lake" and a dataset named "gh-archive-all" in Google BigQuery.


## Establish data ingestion using Airflow.

- Go to `archive_github/airflow`
- Run the following command and write down the output:
```sh
echo -e "AIRFLOW_UID=$(id -u)"
```
- Access the `.env` file and update the AIRFLOW_UID value to match the output of the preceding command.
- Update the `GCP_PROJECT_ID` with your Google Cloud project ID and replace `GCP_GCS_BUCKET` with the name of your bucket.
- Build the custom Airflow Docker image: 
```sh
docker-compose build
```
- Initialize the Airflow configs:
```sh
docker-compose up airflow-init
```
- Start airflow
```sh
docker-compose up
```

- You can now view the Airflow web interface by navigating to localhost:8080. Use "airflow" as both the username and password.

## Execute the data ingestion process
- This DAG retrieves data from February 1, 2024, up to February 27, 2024.
- You can modify the start date and end date by editing the variables `start_date` and `end_date` in the data_ingestion.py file.
- To trigger the DAG, toggle the switch icon next to the DAG name. It will fetch data from the specified start date to the latest available hour and perform hourly checks every 30 minutes.
- After ingestion, you can stop Airflow by running `docker-compose down` in the airflow folder where the `docker-compose.yaml` file is located.
- Remember to power off the VM in Google Cloud Platform to prevent incurring unnecessary costs.

## Establishing the configuration for dbt Cloud.

- Sign up for a dbt Cloud account at https://www.getdbt.com/signup.
- Create a new project and name it, such as `gh-archive`. In the Advanced settings, set the Project subdirectory to `dbt`.
- Choose BigQuery as the database connection.
- Configure the following settings:
  - You can keep the default connection name.
  - Upload the Service Account JSON file, selecting the "google_credentials.json" created previously.
  - Ensure to input your Google Cloud location under Location (for e.g., US).
  - Under Development credentials, specify a name for the dataset. This name will be added as a prefix to the schemas. For example, use "dbt".
  - Test the connection, and click Continue once the connection is successfully tested.
- In the Add repository form, select GitHub and choose your fork from your user account. Alternatively, you can provide a URL and clone the repo.
- Once the project is created, navigate to the menu on the top left and click Develop to load the dbt Cloud IDE.
- You can now run the `dbt run` command in the bottom prompt to execute all models. This will generate three different datasets in BigQuery:
    - `dbt_core`: Contains the end-user tables.
    - `dbt_dwh`: Stores the data warehouse materialized table with all ingested data.
    - `dbt_staging`: Contains the staging views for generating the final end-user tables.

- Just for your information, I encountered some issues while running dbt run. The issue emerged due to errors related to the timestamp format for the `created at` field.
- To resolve this, I had to include the following line in the Airflow DAG:

`df['created_at'] = pd.to_datetime(df['created_at']).dt.strftime('%Y-%m-%d %H:%M:%S')`
- This adjustment allowed dbt run to execute successfully.

## Rolling out models in dbt Cloud in a Production environment
Here's how to deploy models in dbt Cloud with a Production environment:

- Click on the menu in the top left corner and select "Environments".
- Click on the "New Environment" button located in the top right corner.
- Provide a name for the environment (e.g., "Production"). Ensure that the environment type is set to "Deployment". In the Credentials section, you can specify a name in the Dataset field, which will add a prefix to the schemas. 
- Create a new job with the following settings:
- Give it a name (e.g., `dbt start`).
- Choose the environment created in the previous step.
- In the Commands section, add the command `dbt run`.
- In the Triggers section, within the Schedule tab, ensure that the "Run on schedule?" checkbox is selected.
- Choose a custom cron schedule and input the string `40 * * * *`. This will execute the models every hour at the 40th minute. (Note: the DAG runs on the 30th minute, so the 10-minute delay ensures that the DAG is successfully executed.)
- Save the job.

## Developing a dashboard with Looker Studio
- Go to https://lookerstudio.google.com/
- Click on `Create` on the top left.
- Select `Report`.
- Select `Bigquery` in the list.
- Select your project.
- Select the dataset `production core`.
- Select the table `users`.
- Click on `add ` on the right bottom.
- on the popup, click `Add to report`.
- Delete the default chart.
- Click on `Add a chart` In our example, we select `table`.
- A table with `actor_login` and `Record Count` is added to the screen.
- From the `data` panel on the left, drop down the `commit_count` to the left under `Metric`.
- Under `Metric`, delete the `record Count`.

You now have your first chart. Let's proceed with the second chart.

- Click on the bottom right `Add Data`.
- Repeat the same steps by selecting the dataset `production staging` this time and select `stg_commits`.
- Click on `add` on the bottom right.
- On the pop up, click `Add to report`.
- Click on `Add a chart` and select `Bar`.
- On the `data` area on the right, select `stg_commits`, then drop down the `created_at` field to the left under `Data Range Dimension`.
- In Metrics,add the `Record Count`.

You now have your second chart.
you can change the name of your reports on the top left by clicking on `Untitled Report`.
