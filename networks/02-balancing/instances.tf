##########
# instance
##########

resource "yandex_compute_instance" "vm-1" {
  name     = var.vm_name
  zone     = "ru-central1-b"
  hostname = "nat"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-1.id
    nat        = true
    ip_address = var.internal_nat_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name     = var.vm2_name
  zone     = "ru-central1-b"
  hostname = "vm-2"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm2_image
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-1.id
    nat        = true
    ip_address = var.vm2_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}


resource "yandex_compute_instance" "vm-3" {
  name     = var.vm3_name
  zone     = "ru-central1-b"
  hostname = "vm-3"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.vm3_image
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-2.id
    ip_address = var.vm3_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}
