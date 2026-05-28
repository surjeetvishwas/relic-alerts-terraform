terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "2.49.1"
    }
  }
  #backend "s3" {
  #  bucket         = "zenput-terraform-state"
  #  dynamodb_table = "zenput-terraform-lock"
  #  encrypt        = true
  #  key            = "terraform-remote-state/newrelic/terraform.tfstate"
  #  region         = "us-east-1"
  #}
}


provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
}
