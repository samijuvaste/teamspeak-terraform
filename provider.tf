terraform {
  required_version = ">= 1.0.0"
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.18"
    }
  }
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
