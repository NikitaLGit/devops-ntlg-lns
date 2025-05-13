variable "diskmgmt" {
  type = map
  default = {
    type = "network-hdd"
    size = 1
    block_size = 4096
  }
}

resource "yandex_compute_disk" "empty-disk" {
  count = 3
  
  name       = format("disk-%02d", count.index + 1)
  type       = var.diskmgmt.type
  zone       = var.default_zone
  size       = var.diskmgmt.size
  block_size = var.diskmgmt.block_size
}

resource "yandex_compute_instance" "storagevm" {
    name = "storage"
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
    
    dynamic secondary_disk {
        for_each = "${yandex_compute_disk.empty-disk.*.id}"
        content {
          disk_id = secondary_disk.value
        }
    }  

    network_interface {
        subnet_id           = yandex_vpc_subnet.develop.id
        nat                 = var.network_interface.nat
    }

    metadata = {
        serial-port-enable = var.metadata_base.serial-port-enable
        ssh-keys           = "storage:${local.ssh_key}"
    }
}