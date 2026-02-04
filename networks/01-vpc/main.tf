terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9"
}

provider "yandex" {
  # token     = var.token
  cloud_id                  = var.cloud_id
  folder_id                 = var.folder_id
  service_account_key_file  = file("~/.authorized_key.json")
  zone                      = var.default_public.zone
}

resource "yandex_vpc_network" "vpcnetwork" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.default_public.name
  zone           = var.default_public.zone
  network_id     = yandex_vpc_network.vpcnetwork.id
  v4_cidr_blocks = [var.default_public.cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = var.default_private.name
  zone           = var.default_private.zone
  network_id     = yandex_vpc_network.vpcnetwork.id
  v4_cidr_blocks = [var.default_private.cidr]

  route_table_id = yandex_vpc_route_table.private_rt.id
}

resource "yandex_vpc_route_table" "private_rt" {
  network_id = yandex_vpc_network.vpcnetwork.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}