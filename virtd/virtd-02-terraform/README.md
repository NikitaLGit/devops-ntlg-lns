## Задание 1

Проверим версию `terraform`

<img src="https://github.com/user-attachments/assets/19b8b033-8c0f-4e1b-a47a-05a1da28830f" width="450">

#### 1-3.
Создадим сервисный аккаунт adminlns. Выпустим ключ. Проверим:
```yaml
service-account-key:
  id: aje08alt7ra********
  service_account_id: ajeq86nce6********
  created_at: "2025-05-05T13:06:52.793349941Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAs********
    -----END PUBLIC KEY-----
  private_key: |
    PLEASE DO NOT REMOVE THIS LINE! Yandex.Cloud SA Key ID <aje08alt7*******>
    -----BEGIN PRIVATE KEY-----
    MIIEvAIBADANBgkqhkiG9w0BAQEFAA********
    -----END PRIVATE KEY-----
cloud-id: b1gv70mvh8q*********
folder-id: b1gntd1fa9********
compute-default-zone: ru-central1-b
```

#### 4.
Иницализируем проект. При запуске `terraform plan` запрашивает данные по `folder_id` и `cloud_id`. Создадим файл `provider.auto.tfvars` и добавим в него 2 переменные: `folder_id`; `cloud_id`.
при `terraform apply` появляется первая ошибка:

![image](https://github.com/user-attachments/assets/51caa7c3-513b-481d-a5b8-9bf1eca4c91d)

Меняем с `v4` на `v3` (всего 3 варианта платформы в YC) и неправильно написано `standard`, а не `standart`. Ниже документация YC по платформам:

<img src="https://github.com/user-attachments/assets/af2c6ec6-a097-4137-9c17-3712a8feb18a" width="550">

Теперь ошибка:

![image](https://github.com/user-attachments/assets/5fc4b429-b28f-480c-83e1-60fb69dd6d0b)

Указан параметр `Гарантированная доля vCPU` в  `5%`, разрешено только `20` `50` или `100`. меняем на `20`.
Дальше ошибка по ядрам. Указано `1`. нужно выбрать `2` или `4`. Выбираем `2`. После исправлений код рабоотает:

<img src="https://github.com/user-attachments/assets/b5a535f6-3619-49fd-a427-31a7356a1edb" width="550">

![image](https://github.com/user-attachments/assets/95e965a5-dedb-45df-961d-d7f43f1fa9f4)

#### 5.
Зайдем в машину:

<img src="https://github.com/user-attachments/assets/684e9025-c3ab-44dd-acd8-68f4061b71e9" width="550">
<img src="https://github.com/user-attachments/assets/3da21906-d8f1-4fee-91f7-8b2af285bae9" width="550">
<img src="https://github.com/user-attachments/assets/8010bda3-1603-4bfc-b23c-3385298a95ff" width="550">

> [!TIP]
> `preemptible = true` – указывает на то, чтот машина будет прерываемой. Это сильно сэкономит ресурсы.
> 
> `core_fraction=5` – указывает на `Гарантированная доля vCPU` в `5%`. Это так же поможет сократить расходование ресурсов. Такую долю поддерживают платформы `standard-v1` и `standard-v2`.

## Задание 2

Заменим весь хардкод в указанных ресурсах на переменные.
Файл объявления переменных:

<img src="https://github.com/user-attachments/assets/3f422680-aeb2-423e-b5bf-bfecf243bb80" width="450">

Измененный файл `main.tf`:

<img src="https://github.com/user-attachments/assets/d6e8b2e7-1144-430a-990d-6097357e93c4" width="450">

После запуска `terraform apply` получаем:

![image](https://github.com/user-attachments/assets/3978bcf3-919f-447e-a258-cd268b744efe)

## Задание 3

Создадим файл `vms_platform.tf` и перенесем данные в файл `main.tf`:
```yaml
resource "yandex_compute_instance" "database" {
  name        = var.vm_db.name
  platform_id = var.vm_db.platform_id
  resources {
    cores         = var.vm_db.cores
    memory        = var.vm_db.memory
    core_fraction = var.vm_db.core_fraction
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
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```

Файл `vms_platform.tf`:
```yaml
variable "vm_web" {
  type = object({
    family          = string
    name            = string
    platform_id     = string
    cores           = number
    memory          = number
    core_fraction   = number
  })
  default = {
    family          = "ubuntu-2004-lts"
    name            = "netology-develop-platform-web"
    platform_id     = "standard-v3"
    cores           = 2
    memory          = 1
    core_fraction   = 20
    }
}

variable "vm_db" {
  type = object({
    family          = string
    name            = string
    platform_id     = string
    cores           = number
    memory          = number
    core_fraction   = number
  })
  default = {
    family          = "ubuntu-2004-lts"
    name            = "netology-develop-platform-db"
    platform_id     = "standard-v3"
    cores           = 2
    memory          = 2
    core_fraction   = 20
    }
}
```

В кабинете появилась наша новая машина:

![image](https://github.com/user-attachments/assets/b358c922-aae0-4c59-947d-ba51010ffac6)

## Задание 4

В файл `outputs.tf` напишем:
```yaml
output "test" {
  value = [
    { platform = ["platform: instanse_name is ${yandex_compute_instance.platform.name}; fqdn is ${yandex_compute_instance.platform.fqdn}; external ip is ${yandex_compute_instance.platform.network_interface[0].nat_ip_address}"]},
    { database = ["database: instanse_name is ${yandex_compute_instance.database.name}; fqdn is ${yandex_compute_instance.database.fqdn}; external ip is ${yandex_compute_instance.database.network_interface[0].nat_ip_address}"]}
  ]
}
```

В выводе получим:

![image](https://github.com/user-attachments/assets/1bffd89a-19e1-4626-befc-6ffd352ca2a0)

## Задание 5

В файл `locals.tf` пропишем:
```yaml
locals {
    provider_name = "${var.naming["web"].who}-${var.naming["web"].name}"
    database_name = "${var.naming["db"].who}-${var.naming["db"].name}"
}
```

В файле `variables.tf` добавим переменную `namimg` в которой будет 2 объекта списка для `web` и `db` соответственно:
> [!TIP]
> Параметр `who` можно разделить еще на 3 части по аналогии, но они одинаковы, поэтому решил сделать так.

```yaml
variable "naming" {
  type = map(object({
    who   = string
    name  = string
  }))
  default = {
    "web" = {
      who   = "netology-develop-platform"
      name      = "web"
    },
    "db" = {
      who   = "netology-develop-platform"
      name      = "db"
    }
  }
}
```

Изменения в файле `main.tf`:
```yaml
resource "yandex_compute_instance" "platform" {
  name        = local.provider_name
```
```yaml
resource "yandex_compute_instance" "database" {
  name        = local.database_name
```

При выполнение `terraform plan` видим, что все аналогично и изменений не будет:

![image](https://github.com/user-attachments/assets/50c946eb-640a-4cd0-b202-0bc24e202744)

## Задание 6

> [!WARNING]
> Не совсем понял смысл задачи. Можно вместо указания 3х переменных сделать ссылку на список параметров в определнной переменной и все?
>
> Сейчас сделал так. (по факту в ресурсе так же указано 3 переменной)

В файле `vms_platform.tf` добавим переменную `vms_resources` (указал 2 варианта: `low` – для низконагруженных систем и `mid` – для средненагруженных) . Из переменных `vm_db` и `vm_web` удалим параметры, которые дублируются:
```yaml
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    low = {
      cores=2
      memory=1
      core_fraction=5
    },
    mid ={
      cores=4
      memory=2
      core_fraction=20
    }
  }
} 
```

В файле `main.tf` сделаем изменения:
```yaml
resource "yandex_compute_instance" "platform" {
  resources {
    cores         = var.vms_resources["low"].cores
    memory        = var.vms_resources["low"].memory
    core_fraction = var.vms_resources["low"].core_fraction
  }

resource "yandex_compute_instance" "database" {
  resources {
    cores         = var.vms_resources["mid"].cores
    memory        = var.vms_resources["mid"].memory
    core_fraction = var.vms_resources["mid"].core_fraction
  }
```

Отдельная переменная `metadata_base`:
```yaml
variable "metadata_base" {
  type = map
  default = {
    serial-port-enable = 1
    ssh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
  }
}
```

Параметр `metadata` теперь выглядит так:
```yaml
metadata = {
    serial-port-enable = var.metadata_base.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_base.ssh-key}"
  }
```

Применим обновления и получим верный исход (В `web` поменяли процесс и `% vcpu` понизили с `20` до `5`. в `db` увеличили количесвто ядер с `4` до `2`)

![image](https://github.com/user-attachments/assets/ac7d4d16-9fe8-4a82-8080-a8b65f7dcca0)

## Задание 7

Зайдем в консоль `terraform`:

#### 1.
Отобразим второй элемент списка `test_list`:
```bash
> local.test_list[1]
"staging"
```

#### 2.
Найдем длину списка `test_list`:
```bash
> length(local.test_list)
3 
```

#### 3.
Отобразим значение ключа `admin` из `map` `test_map`:
```bash
> local.test_map["admin"]
"John"
```

#### 4. 
```bash
> "${local.test_map["admin"]} is admin for ${local.test_list[2]} server based on OS ${local.servers.stage.image} with ${local.servers.stage.cpu} vcpu, ${local.servers.stage.ram} ram and ${length(local.servers.stage.disks)} virtual disks"
"John is admin for production server based on OS ubuntu-20-04 with 4 vcpu, 8 ram and 2 virtual disks"
```

![image](https://github.com/user-attachments/assets/81b119ba-d4ae-43ff-a0c9-b172e742a9d3)

## Задание 8

#### 1.
не совем понял что создать.

#### 2.
Добавил код из `8.1` в `locals`. Чтобы получить требуемую строку введем:
```bash
> local.test[0].dev1[0]
"ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"
```

## Задание 9

Создадим через веб клиента шлюз:

![image](https://github.com/user-attachments/assets/7f425333-fbc5-40c6-afbc-9dae4c937dd9)

Потом таблицу маршрутизации через шлюз:

![image](https://github.com/user-attachments/assets/24b682dd-ebdc-4f11-904f-ee21b3c3ccd4)

В сеть добавим таблицу маршрутизации:

![image](https://github.com/user-attachments/assets/d2510eed-8515-4fbc-bc06-b6ff72e5ab55)

Пропишем в машинах `nat=false` (заранее добавили пароли для пользователя `ubuntu`). Для применения запускаем `terraform apply` с ключем `-lock=false`. В машине пропал внешний адрес:

![image](https://github.com/user-attachments/assets/6c46fb87-822d-45d9-b768-8b7a157faf14)

Пинги идут:

![image](https://github.com/user-attachments/assets/e03aa057-52fa-497b-b8af-2e7893c98a31)
