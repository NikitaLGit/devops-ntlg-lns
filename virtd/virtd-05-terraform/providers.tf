terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9"

backend "s3" {
  endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "tfstate-lns-1"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенsда для Terraform версии 1.6.3 и старше.

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gv70mvh8quh0edjcqr/etndujbvilthn7u74v52"
    dynamodb_table = "tfstate-lock"
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
