terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.141.0"
    }
  }
  required_version = "~>1.9"

backend "s3" {
  endpoints = {
    s3 = "https://storage.yandexcloud.net"
  }
  bucket = "ans-tfstate"
  region = "ru-central1"
  key    = "ansible-03-test/vms_dev/terraform.tfstate"

  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_s3_checksum            = true

  dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gv70mvh8quh0edjcqr/etnatuj9sjkivpk5u2nr"
  dynamodb_table = "tfstate-lock"
  }
}

provider "yandex" {
  cloud_id                  = var.cloud_id
  folder_id                 = var.folder_id
  zone                      = var.zone
}