terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_compute_image" "my_image" {
  family = "ubuntu-2204-lts"
}

output "my_image_id" {
  value = data.yandex_compute_image.my_image.id
}