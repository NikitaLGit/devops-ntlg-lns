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
    key    = "ansible-03-test/vpc_dev/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gv70mvh8quh0edjcqr/etnatuj9sjkivpk5u2nr"
    dynamodb_table = "tfstate-lock"
  }
}

resource "yandex_vpc_network" "ans_net" {
  name = var.env_name
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "ans_subnet" {
  for_each = { for i, s in var.subnets: i => s }
  name = "${var.env_name}-${each.value.zone}"
  zone = each.value.zone
  folder_id = var.folder_id
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.ans_net.id
}