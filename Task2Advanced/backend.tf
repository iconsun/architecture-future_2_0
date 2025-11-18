terraform {
  backend "s3" {
    endpoints = {
      s3 = "http://localhost:9000"
    }

    bucket = "tfstate"
    key    = "Task2Advanced/terraform.tfstate"
    region = "us-east-1"

    access_key = "minioadmin"
    secret_key = "minioadmin123"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true


    use_path_style = true
  }
}
