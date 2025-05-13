![image](https://github.com/user-attachments/assets/73c2722b-3892-492a-b5ee-bc9d564bb7f4)## Проверим версию `terraform`

![image](https://github.com/user-attachments/assets/1b16ec7c-1646-4c5c-a842-9d3d6d1031ba)

## Задание 1

Поменял версию провайдера yandex cloud с `1.8` на `1.5`
Выполним код и зайдем в группы безопасности:

![image](https://github.com/user-attachments/assets/fd699548-a0c6-4efa-92be-07c566bdf9a7)

## Задание 2

Создадим файл `count-vm.tf` в которой опишем создание указанное количество аналогичных машин:
```yaml
resource "yandex_compute_instance" "ter3vm" {
  count = 2

  name        = format("ter3vm-%02d", count.index + 1)
  hostname    = format("ter3vm-%02d", count.index + 1)
  description = format("ter3vm-%02d", count.index + 1)
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
    nat                 	= var.network_interface.nat
  }

  metadata = {
    serial-port-enable = var.metadata_base.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_base.ssh-key}"
  }
}
```

В файлы переменных добавим все нужные переменные из предыдущего урока ,которые повторяем в этом: `metadata_base`, `platform`, `vms_resources`.
Запустим` terraform apply` и получим в личном кабинете 2 вм, порядековый номер которых начинается с 1, а не с 0:

![image](https://github.com/user-attachments/assets/875eb00f-b01b-4574-86f7-58eea39af9a4)
![image](https://github.com/user-attachments/assets/7c1cdf5c-189a-459f-bf1d-dd665897cc0a)

Добавим обе машины в нашу группу безопасности. В файл `count-vm.tf` в `network_interface` добавим список строк `security_group_ids`:
```yaml
network_interface {
    subnet_id           = yandex_vpc_subnet.develop.id
    nat                 = var.network_interface.nat
    security_group_ids  = [yandex_vpc_security_group.example.id]
  } 
```

Применим изменения.

Создадим файл `for_each-vm.tf`:
```yaml
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
        ssh_key            = string
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
        ssh_key            = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
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
        ssh_key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
        ssh_user           = "replica"
    }
    }]
}

resource "yandex_compute_instance" "ter3foreach" {
    for_each = { for idx, vm in var.each_vm : vm.vm_name => vm }

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
        ssh-keys           = "${each.value.metadata.ssh_user}:${each.value.metadata.ssh_key}"
    }
}
```

Получается 2 машины с разными параметрами:

![image](https://github.com/user-attachments/assets/4f7b6b3b-73f3-4ee9-8da9-b5970d928d63)
![image](https://github.com/user-attachments/assets/59e1f1a7-a87e-4ed3-92ce-034c70c6b4e7)

Чтобы машины из задания `2.1` создавались после машин `2.2` (ресурс `yandex_compute_instance.ter3foreach`), нужно в ресуры создания вм добавить параметр `depends_on`:
```yaml
depends_on = [ yandex_compute_instance.ter3foreach ]
```

Добавим новый файл `locals.tf` и в нем:
```yaml
locals {
  ssh_key = file("~/.ssh/id_ed25519.pub")
}
```

В ресурсах замени с конструкцию `var.metadata_base.ssh-key` на `local.ssh_key`.

## Задание 3

Cоздадим файл `disk_vm.tf` и в нем напишем:
```yaml
resource "yandex_compute_disk" "empty-disk" {
  count = 3
  
  name       = format("disk-%02d", count.index + 1)
  type       = var.diskmgmt.type
  zone       = var.default_zone
  size       = var.diskmgmt.size
  block_size = var.diskmgmt.block_size
}

variable "diskmgmt" {
  type = map
  default = {
    type = "network-hdd"
    size = 1
    block_size = 4096
  }
}
```

Получим 3 диска `disk-01` `disk-02` `disk-03` размером 1гб:

![image](https://github.com/user-attachments/assets/498ca800-cccd-4ec2-8d38-aa4b52ea27cf)

Добавим блок `dynamic secondary_disk` в ресурс `resource "yandex_compute_instance" "storagevm"`:
```yaml
dynamic secondary_disk {
        for_each = "${yandex_compute_disk.empty-disk.*.id}"
        content {
          disk_id = secondary_disk.value
        }
    }  
```

Запустим `terraform plan` и увидим, что все 3 диска добавятся:
```yaml
+ secondary_disk {
          + auto_delete = false
          + device_name = (known after apply)
          + disk_id     = "epd06rr6e9mvek0um8fb"
          + mode        = "READ_WRITE"
        }
      + secondary_disk {
          + auto_delete = false
          + device_name = (known after apply)
          + disk_id     = "epdht51a3kv5v18h46rj"
          + mode        = "READ_WRITE"
        }
      + secondary_disk {
          + auto_delete = false
          + device_name = (known after apply)
          + disk_id     = "epdti59qtn2nhbqgsqda"
          + mode        = "READ_WRITE"
        }
```

![image](https://github.com/user-attachments/assets/6c15d046-39f7-407b-9849-f270a0356318)

## Задание 4

Создадим файл `ansible.tf` и в нем:
```yaml
resource "local_file" "hosts_cfg" {
    content = <<-EOT
    %{if length(yandex_compute_instance.ter3count) > 0}
    [webservers]
    %{for i in yandex_compute_instance.ter3count}
    ${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
    %{endfor}
    %{endif}

    %{if length(yandex_compute_instance.ter3foreach) > 0}
    [databases]
    %{for s in yandex_compute_instance.ter3foreach}
    ${s["name"]} ansible_host=${s["network_interface"][0]["nat_ip_address"]} fqdn=${s["fqdn"]}
    %{endfor}
    %{endif}
 
    %{if length(yandex_compute_instance.storagevm) > 0}
    [storage]
    ${yandex_compute_instance.storagevm.name} ansible_host=${yandex_compute_instance.storagevm.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.storagevm.fqdn}
    %{endif}

    EOT
    filename = "${abspath(path.module)}/hosts.cfg"
}
```

Файл `hosts.cfg`:

![image](https://github.com/user-attachments/assets/ed6f19cb-bf49-4bf2-bfe8-62fe263c9bb0)

## Задание 5
## Задание 6
## Задание 7
## Задание 8
## Задание 9
