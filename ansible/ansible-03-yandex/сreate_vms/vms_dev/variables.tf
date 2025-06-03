variable "folder_id" {
  type = string
  sensitive = true
}
variable "cloud_id" {
  type = string
  sensitive = true
}
variable "zone" {
  type = string
  sensitive = true
}

variable "subnet_id" {
  type = string
  sensitive = true
}

variable "metadata_base" {
  type = object({
    ssh_name = string
    serial-port-enable = number
    ssh_public_key = string
  })
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    platform_id = string
    resources   = object({
      cores         = number
      memory        = number
      core_fraction = number
    })
    boot_disk = object({
      size = number
      type = string
      image_id = string
    })
    network_interface = object({
      nat = bool
    })
    metadata = object({
      serial-port-enable = string
      ssh_keys           = string
      ssh_user           = string
    })
}))

  default = [{
    vm_name     = "clickhouse-01"
    platform_id = "standard-v3"
    resources   = {
      cores         = 2
      memory        = 2
      core_fraction = 20
  }
  boot_disk = {
    size = 10
    type = "network-hdd"
    image_id = "fd8aus3bfglr6dg9hsbk"
  }
  network_interface = {
    nat = true
  }
  metadata = {
    serial-port-enable = 1
    ssh_keys  = "None"
    ssh_user  = "ansible "
  }
  },
  {
  vm_name     = "vector-01"
  platform_id = "standard-v3"
    resources   = {
      cores         = 2
      memory        = 2
      core_fraction = 20
  }
  boot_disk = {
    size = 10
    type = "network-hdd"
    image_id = "fd8aus3bfglr6dg9hsbk"
  }
  network_interface = {
    nat = true
  }
  metadata = {
    serial-port-enable = 1
    ssh_keys      = "None"
    ssh_user     = "ansible"
  }
  },
  {
  vm_name     = "lighthouse-01"
  platform_id = "standard-v3"
    resources   = {
      cores         = 2
      memory        = 2
      core_fraction = 20
  }
  boot_disk = {
    size = 10
    type = "network-hdd"
    image_id = "fd8aus3bfglr6dg9hsbk"
  }
  network_interface = {
    nat = true
  }
  metadata = {
    serial-port-enable = 1
    ssh_keys      = "None"
    ssh_user     = "ansible"
  }
  }
  ]
}
