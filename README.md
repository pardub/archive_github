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
  - 
![picture_project_infrastructure](https://github.com/pardub/archive_github/assets/42610272/d9aca2f0-6596-4da2-8e1e-4917f8b3fc43)

### Dashboard
![Looker_final_project](https://github.com/pardub/archive_github/assets/42610272/15106599-d017-4fe8-a74f-99d7b8f29225)

# Setup

You will need :
- A Google Cloud Platform account https://cloud.google.com/

To replicate the project, you'll need the following :

A Google Cloud Platform (GCP) account.
(Optional) The Google Cloud SDK for streamlined installation and management.
(Optional) An SSH client for terminal access.
(Optional) VSCode with the Remote-SSH extension for convenient port forwarding.
The development and testing phase utilized a Google Cloud Compute VM instance. It's highly recommended to employ a VM instance for reproducing the project.

# Generate a Google Cloud Project
- Navigate to the Google Cloud dashboard and initiate the creation of a new project by selecting it from the dropdown menu positioned at the top left corner of the screen, adjacent to the Google Cloud Platform label.
- Upon project creation, proceed to establish a Service Account with the specified roles:

    * BigQuery Admin
    * Storage Admin
    * Storage Object Admin
    * Viewer
      
Download the credentials file for the Service Account and rename it to google_credentials.json. Store this file in your home folder at $HOME/.google/credentials/.

Note: If you're utilizing a VM as advised, ensure to upload this credentials file to the VM.

Activate the following APIs:

IAM API: https://console.cloud.google.com/apis/library/iam.googleapis.com
IAM Credentials API: https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
If any of these steps seem unfamiliar, please refer to Lesson 1.3.1 - Introduction to Terraform Concepts & GCP Pre-Requisites on YouTube, or consult my notes for guidance.

## Establishing an environment variable for the credentials

- Set up an environment variable named GOOGLE_APPLICATION_CREDENTIALS and allocate it the pathway to your JSON credentials file, typically located at $HOME/.google/credentials/.

- Run this command that will append the export statement to the .bashrc file in your home directory. Make sure to replace <path/to/authkeys>.json with the actual path to your JSON credentials file.

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

