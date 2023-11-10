terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "airbyte_data_synchronization_failures" {
  source    = "./modules/airbyte_data_synchronization_failures"

  providers = {
    shoreline = shoreline
  }
}