terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "null" {}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Task2Advanced: infrastructure applied"
  }
}
