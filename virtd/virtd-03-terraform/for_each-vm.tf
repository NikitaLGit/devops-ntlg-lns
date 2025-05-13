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
    })
    network_interface = object({
        nat = bool
    })
    metadata = object({
        serial_port_enable = bool
        ssh_keys           = string
        ssh_user           = string
    })
}))

    default = [{
        vm_name     = "main"
        platform_id = "standard-v3"
        resources   = {
            cores         = 2
            memory        = 4
            core_fraction = 20
    }
    boot_disk = {
        size = 20
        type = "network-hdd"
    }
    network_interface = {
        nat = true
    }
    metadata = {
        serial_port_enable = true
        ssh_keys      = "None"
        ssh_user           = "ubuntu"
    }
    },
    {
    vm_name     = "replica"
    platform_id = "standard-v1"
    resources   = {
        cores         = 2
        memory        = 1
        core_fraction = 5
    }
    boot_disk = {
        size = 10
        type = "network-hdd"
    }
    network_interface = {
        nat = false
    }
    metadata = {
        serial_port_enable = true
        ssh_keys      = "None"
        ssh_user     = "replica"
    }
    }]
}

resource "yandex_compute_instance" "ter3foreach" {
    for_each = { for vm in var.each_vm : vm.vm_name => vm }

    name = each.value.vm_name
    platform_id = each.value.platform_id

    resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
    }

    boot_disk {
        initialize_params {
        image_id = data.yandex_compute_image.ubuntu.image_id
        size     = each.value.boot_disk.size
        type     = each.value.boot_disk.type
            }
    }

    network_interface {
        subnet_id          = yandex_vpc_subnet.develop.id
        nat                = each.value.network_interface.nat
        security_group_ids = [yandex_vpc_security_group.example.id]
    }

    metadata = {
        serial-port-enable = each.value.metadata.serial_port_enable
        ssh-keys           = "${each.value.metadata.ssh_user}:${local.ssh_key}"
    }
}