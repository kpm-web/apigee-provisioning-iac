terraform {
  required_version = ">= 1.12.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.46.1"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.46.1"
    }
  }
  # Configure the storage for the state file. By default it uses local
  # Depending on the storage bucket provider change the value from "gcs" to suitable
  #backend "gcs" {
  #}
}
