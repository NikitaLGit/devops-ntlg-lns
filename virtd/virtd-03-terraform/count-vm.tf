resource "yandex_compute_instance" "ter3count" {
  count = 2

  name        = format("ter3count-%02d", count.index + 1)
  hostname    = format("ter3count-%02d", count.index + 1)
  description = format("ter3count-%02d", count.index + 1)
  folder_id   = var.folder_id
  zone        = var.default_zone

  allow_stopping_for_update = var.platform.allow_stopping_for_update

  resources {
    cores         = var.vms_resources["low"].cores
    memory        = var.vms_resources["low"].memory
    core_fraction = var.vms_resources["low"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.platform.size
      type     = var.platform.type
    }
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.develop.id
    nat                 = var.network_interface.nat
    security_group_ids  = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = var.metadata_base.serial-port-enable
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }

  depends_on = [ yandex_compute_instance.ter3foreach ]
}