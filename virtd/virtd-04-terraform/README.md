Проверим версию `terraform`

![image](https://github.com/user-attachments/assets/2d7786d2-bd3a-44b6-ae26-67aebf4be96b)

## Задание 1

Возьмем файлы:

![image](https://github.com/user-attachments/assets/4ae4bf6e-9e6c-4095-8627-b8747e864a59)

Переведем весь хардкод в переменные `variables.tf`
В `labels` создаваемых `вм` вставим нужные по заданию (`test-vm` – `marketing`, `example-vm` – `analytics`)
Чтобы прокинуть `ssh` ключ через `template file`, добавим в `data` `"template_file"` `"cloudinit"`.
```yaml
vars = {
    ssh_public_key = var.metadata_base.ssh_public_key
  }
```

А в файле cloud-init.yml поменяем значение ssh_authorized_keys на 
```yaml
- ${ssh_public_key}
```

В файл `cloud-init.yml` после – `vim` добавим `-nginx` для установки.
Запустим `terraform apply` и получим 3 вм, сеть `develop` и 2 подсети `a` и `b` в ней.

![image](https://github.com/user-attachments/assets/d9f017c6-783b-4ae4-9df6-5230a5bbc7f6)

Проверим что `nginx` установился везде правильно:

![image](https://github.com/user-attachments/assets/20c0739d-1b11-4ecc-afe6-ca6e46bc8f3a)
![image](https://github.com/user-attachments/assets/74aba029-5c70-4b64-b01f-c5c2ea9e1908)
![image](https://github.com/user-attachments/assets/a5feac3f-b3b5-4cee-9200-4ddefa3af3ed)

## Задание 2

В папке `.terraform/module` создадим создадим папку `vpc`. Вложим в нее пустой `main.tf` файл.
В root модуле `main.tf` пропишем новый модуль с указанием источника на нашу новую папку:
```yaml
module "vpc_create" {
  source         = "./vpc"
}
```

В файле `main.tf` модуля пропишем создание сети и подсети `а`:
```yaml
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9"
}
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

resource "yandex_vpc_subnet" "develop_a" {
    name = "develop-ru-central1-a"
    zone = "ru-central1-a"
    v4_cidr_blocks = ["10.0.1.0/24"]
    network_id     = yandex_vpc_network.develop.id
}
```

Теперь в папку модуля нужно добавтиь файл `outputs.tf` через который будем получать данные переменных в модуле.
```yaml
output "net_id" {
  value = yandex_vpc_network.develop.id
}
output "subnet_id" {
  value = yandex_vpc_subnet.develop_a.id
}

output "name" {
  value = yandex_vpc_subnet.develop_a.name
}
output "zone" {
  value = yandex_vpc_subnet.develop_a.zone
}
output "cidr" {
  value = yandex_vpc_subnet.develop_a.v4_cidr_blocks
}
```

Теперь в основном файле нужно переписать ссылки на переменные, которые перенесли в модуль.
```yaml
network_id     = "${module.vpc_create.net_id}"
subnet_zones   = ["${module.vpc_create.zone}", var.default_sub_b.zone]
subnet_ids     = ["${module.vpc_create.subnet_id}",yandex_vpc_subnet.develop_b.id]
```

Назвал модуль `vpc_create`, а не `vpc_dev` (потом по ходу движения заменю на верное).

![image](https://github.com/user-attachments/assets/86c37b59-25c2-4884-a3bf-6224abd8801f)

По ссылке из презентации ничего не работает. Не находит образ `markdown`. Поставил `terraform-docs` с помощью `snap` 
```bash
sudo snap install terraform-docs
```

Запустил создание с помощью
```bash
terraform-docs markdown document ./ > terraform_docs.md
```
Файл [terraform_docs.md](https://github.com/NikitaLGit/devops-ntlg-lns/blob/main/virtd/virtd-04-terraform/terraform_docs.md) получился, но не такой красивый, как на скриншотах:

![image](https://github.com/user-attachments/assets/8fb12d61-ea40-42bb-9a0c-1b40cd27fba0)

## Задание 3

Выведем список ресурсов в `state`

![image](https://github.com/user-attachments/assets/9133f7ec-7da1-4e9f-81d3-37f61b2f0456)

Удалим оба ресурса в модуле `vpc` (можно удалить весь модуль командой `terraform state rm ‘module.vpc_create`)

![image](https://github.com/user-attachments/assets/009bac5f-0294-46fd-9085-06562bbe03cb)

Проверим

![image](https://github.com/user-attachments/assets/c0c87a71-179c-4d23-834c-c1a83faf79ff)

Удалим оба модуля создания вм

![image](https://github.com/user-attachments/assets/ee438e75-4efe-4ff2-95d4-18c7300568d3)

Восстановим `module.vpc_create.yandex_vpc_network.develop`

![image](https://github.com/user-attachments/assets/cc829f81-e67a-454b-b296-9698bff448cd)
![image](https://github.com/user-attachments/assets/e1353e17-b6ed-42a6-a601-f6d4d3854d68)
![image](https://github.com/user-attachments/assets/d41a2542-8a46-42ab-83bb-ed8ab17c2be2)
![image](https://github.com/user-attachments/assets/ab0186fc-33b4-4e00-86a3-11576f8a71c5)
![image](https://github.com/user-attachments/assets/a28eb86d-3915-4db3-bf0c-f2c615917e73)

Проверим `terraform plan`. Без изменений

![image](https://github.com/user-attachments/assets/8ade2ddd-5217-4c72-8c25-be6b1c8a908a)

## Задание 4

Создадим 2 папки в проекте: `vpc_dev` и `vpc_prod`

![image](https://github.com/user-attachments/assets/36a69d41-fef5-402b-8241-0e385eacbcf2)

Файл `main.tf` `root` модуля:
```yaml
module "vpc_prod" {
  source       = "./vpc_prod"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.0.3.0/24" }, #не с, а d
  ]
}

module "vpc_dev" {
  source    = "./vpc_dev"
  env_name  = "develop"
  subnets   = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Файл `main.tf` модуля `module "vpc_prod"`
```yaml
resource "yandex_vpc_network" "production" {
  name = var.env_name
}
resource "yandex_vpc_subnet" "sub_prod" {
  for_each = { for i, s in var.subnets: i => s }
  name = "${var.env_name}-${each.value.zone}"
  zone = each.value.zone
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.production.id
}
```

Файл `main.tf` модуля `module "vpc_dev"`
```yaml
resource "yandex_vpc_network" "develop" {
  name = var.env_name
}

resource "yandex_vpc_subnet" "sub_develop" {
  for_each = { for i, s in var.subnets: i => s }
  name = "${var.env_name}-${each.value.zone}"
  zone = each.value.zone
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.develop.id
}
```

Файл `outputs.tf` в модулях (на примере модуля `vpc_dev`)
```yaml
output "net_id" {
  value = yandex_vpc_network.develop.id
}
output "subnet_id" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.id }
}

output "_name" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.name }
}
output "zone" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.zone }
}
output "cidr" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.v4_cidr_blocks }
}
```

Файл `variables.tf` в модулях (на примере модуля `vpc_dev`)
```yaml
variable "env_name" {
  type        = string
  default     = "def_develop"
}

variable "subnets" {
  type = list(object({
    zone=string,
    cidr=string
    }))
  default = [{
    zone = "def_ru-central1-a",
    cidr = "10.0.100.0/24"
  }]
}
```

Теперь нужно заменить переменные в файле проекта
```yaml
subnet_zones   = concat(values(module.vpc_dev.zone), [var.default_sub_b.zone])
subnet_ids     = concat(values(module.vpc_dev.subnet_id), [yandex_vpc_subnet.develop_b.id])
network_id     = "${module.vpc_dev.net_id}"
```

Проверим верность исполнения

![image](https://github.com/user-attachments/assets/c8d9d47e-558e-4a8c-8fc9-3a050b708f42)
![image](https://github.com/user-attachments/assets/2e102d51-fb6b-45c4-a6a0-aed015e78c97)
![image](https://github.com/user-attachments/assets/1e589bdf-3600-41d2-b4e3-a2f14d276097)

## Задание 5

ничего

## Задание 6
> [!WARNING]
> Из модуля предложенного постоянно вылезают ошибки по провайдерам `aws` и `random`

Создал в локальном проекте файл `s3bucket.tf`
```yaml
# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = var.s3_conf.service_name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = var.s3_conf.sa_role
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Создание бакета с использованием статического ключа
resource "yandex_storage_bucket" "netology-s3-1g-bucket" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.s3_conf.name
  max_size              = var.s3_conf.size
  default_storage_class = var.s3_conf.storage_class
  anonymous_access_flags {
    read        = var.s3_conf.flags_read
    list        = var.s3_conf.flags_list
    config_read = var.s3_conf.flags_config_read
  }
  tags = {
    tests3key = "tests3value"
  }

  force_destroy = var.s3_conf.force_destroy
}
```

В файле `variables.tf`
```yaml
variable "s3_conf" {
  type = object({
    service_name = string
    sa_role      = string
    name         = string
    size         = number
    storage_class = string
    flags_read        = bool
    flags_list        = bool
    flags_config_read = bool
    force_destroy    = bool
  })
  default = {
    service_name = "s3admin"
    sa_role      = "storage.admin"
    name         = "netology-s3-1g-bucket"
    size         = 1073741824
    storage_class = "standard"
    flags_read        = true
    flags_list        = true
    flags_config_read = false
    force_destroy    = true
  }
}
```

Запустим `terraform apply`
Получим новый сервисный аккаунт и права доступа на созданный бакет.

![image](https://github.com/user-attachments/assets/20aabfea-9a5f-4b2c-b728-69de175ddd60)

Перенес файл в папку `s3bucket`. Туда же вложим файл с переменными. Добавим объявление провайдера. 
В `root` модуль создадим вызов модуля `s3_create`
```yaml
module "s3_create" {
  source = "./s3bucket"

  token = var.token
  folder_id = var.folder_id
  cloud_id = var.cloud_id
zone = var.default_sub_b.zone
}
```

## Задание 7

Создадим файл `docker-compose.yaml`
Запустим `docker compose up`

![image](https://github.com/user-attachments/assets/4e5a8835-9d45-4b7b-a3ef-ca0528b27e4c)

Зайдем

![image](https://github.com/user-attachments/assets/4ad858c5-01ee-4bd5-a714-bdf4e1e4d28d)

Создадим нужный секрет

![image](https://github.com/user-attachments/assets/12dc9252-e4df-4b84-b4be-c20859ee3526)

Теперь в `root` модуле создадим файл `vault.tf`
```yaml
provider "vault" {
 address = "http://${var.vault.ip}:${var.vault.port}"
 skip_tls_verify = var.vault.skip_tls_verify
 token = var.vault.token_vault
}
data "vault_generic_secret" "vault_example"{
 path = "${var.vault.base_path}/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 
```

Переменная
```yaml
variable "vault" {
   type = object({
    ip              = string
    port            = string
    skip_tls_verify = bool
    token_vault     = string
    base_path       = string
  })
}
```

Переменная есть

![image](https://github.com/user-attachments/assets/0c12b5c6-9f72-4a5f-9590-9b7f934a39f1)

В `output` так же появляется

![image](https://github.com/user-attachments/assets/660d51b6-2e8a-4b94-a65f-c20b49ce3549)

Запустим из консоли

![image](https://github.com/user-attachments/assets/1a070510-cf9d-4338-8eb4-7c60e211f4f5)

> [!WARNING]
> Как передать секрет не понял пока

## Задание 8

Пока ничего
