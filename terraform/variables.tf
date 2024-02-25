locals {
  data_lake_bucket = "pardub_data_lake"  // Local variable defining the name of the data lake bucket
}

// GCP Project ID
variable "project" {
  description = "Your unique identifier for the Google Cloud Platform (GCP) project."
  default = "speedy-baton-407909"  // Default GCP project ID
}

// GCP Region
variable "region" {
  description = "The geographical location where GCP resources will be deployed. Refer to the official GCP documentation for available regions."
  default = "us-central1"  // Default GCP region
  type = string
}

// Storage Class Type for Cloud Storage Bucket
variable "storage_class" {
  description = "The type of storage class to be used for your bucket. Please consult the official GCP documentation for more details."
  default = "STANDARD"  // Default storage class type
}

// BigQuery Dataset Name
variable "BQ_DATASET" {
  description = "The name of the BigQuery dataset where raw data from Google Cloud Storage  will be stored."
  type = string
  default = "gh_archive_all"  // Default BigQuery dataset name
}

// Google Cloud Storage Bucket Name
variable "cloud_storage" {
  description = "The name of the Google Cloud Storage  bucket where raw data will be written."
  type = string
  default = "pardub_dataset_gcs"  // Default GCS bucket name
}

// Compute Engine Instance Name
variable "compute_instance" {
  description = "The name of the Compute Engine instance."
  type = string
  default = "gharhive-instance"  // Default Compute Engine instance name
}

// Machine Type Configuration for Compute Engine Instance
variable "machine_type" {
  description = "The machine type configuration for the Compute Engine instance."
  type = string
  default = "e2-medium"  // Default machine type
}
