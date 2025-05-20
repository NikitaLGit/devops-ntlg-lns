resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web.family
}

resource "yandex_compute_instance" "platform" {
  name        = local.provider_name
  platform_id = var.vm_web.platform_id
  allow_stopping_for_update = var.vm_web.allow_stopping_for_update
  resources {
    cores         = var.vms_resources["low"].cores
    memory        = var.vms_resources["low"].memory
    core_fraction = var.vms_resources["low"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = {
    serial-port-enable = var.metadata_base.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_base.ssh-key}"
  }
}

resource "yandex_compute_instance" "database" {
  name        = local.database_name
  platform_id = var.vm_db.platform_id
  allow_stopping_for_update = var.vm_db.allow_stopping_for_update
  resources {
    cores         = var.vms_resources["mid"].cores
    memory        = var.vms_resources["mid"].memory
    core_fraction = var.vms_resources["mid"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = {
    serial-port-enable = var.metadata_base.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_base.ssh-key}"
  }
}