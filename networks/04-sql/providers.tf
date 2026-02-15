terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      }
  }
  required_version = ">=1.3"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone[0]
#  service_account_key_file = file("~/.ssh/id_ed25519.pub")
  max_retries = 10

}
