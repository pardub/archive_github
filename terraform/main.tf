terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.12.0"  // Specifies the required version of the Google provider
    }
  }
}

provider "google" {
  credentials = file("/home/pardub/Downloads/test_user.json")  // Path to the JSON file containing GCP service account credentials

  project = var.project  // GCP project ID provided as a variable
  region = var.region    // GCP region provided as a variable
}
 

resource "google_compute_instance" "default" {
  name         = var.compute_instance  // Name of the Compute Engine instance provided as a variable
  machine_type = var.machine_type      // Machine type of the Compute Engine instance provided as a variable
  zone         = "${var.region}-c"     // Zone for the Compute Engine instance derived from the provided region variable

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240110"  // Image for the boot disk of the instance
      size=35                                // Size of the boot disk in GB
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_storage_bucket" "data-lake-bucket" {
  
  name          = var.cloud_storage  // Name of the Cloud Storage bucket provided as a variable
  location      = var.region         // Location of the bucket derived from the provided region variable
  storage_class = "STANDARD"         // Storage class of the bucket

  uniform_bucket_level_access = true // Enabling uniform bucket-level access
  force_destroy = true               // Allowing forceful deletion of the bucket
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.BQ_DATASET   // ID of the BigQuery dataset provided as a variable
  project    = var.project       // GCP project ID provided as a variable
  location   = var.region        // Location of the dataset derived from the provided region variable
}
