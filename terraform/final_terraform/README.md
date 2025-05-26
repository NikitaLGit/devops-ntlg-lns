# Краткую документацию по проекту можно найти в [INFO.md](https://github.com/NikitaLGit/devops-ntlg-lns/edit/tftask4/terraform/final_terraform/INFO.md)

* Стейт хранится не локально, а удаленно (в провайдере `main.tf` `root модуля` подключен `backend`, созданный вручную). Включен `state-locking` через `DynamoDB` `YDB`.
* Хардкода нет, все переменные хранятся в скрытых файлах, которые включены в `ignore` файлы

# Оглавление
* [Задание 1](#задание-1)
  * [Создайте Virtual Private Cloud (VPC) + подсети](#task1-1)
  * [Создайте виртуальные машины (VM)](#task1-2)
  * [Настройте группы безопасности (порты 22, 80, 443) + привяжите в VM](#task1-3)
  * [Опишите создание БД MySQL в Yandex Cloud](#task1-4)
  * [Опишите создание Container Registry](#task1-5)
  * [root модуль](https://github.com/NikitaLGit/devops-ntlg-lns/edit/tftask4/terraform/final_terraform/main.tf)
* [Задание 2](#задание-2)
  * [Используя user-data (cloud-init), установите Docker и Docker Compose](#task2-1)
* [Задание 3](#задание-3)
  * [Опишите Docker файл](#task3-1)
  * [Сохраните контейнеры в Container registry](#task3-2)
* [Задание 4](#задание-4)
  * [Завяжите работу приложения в контейнере на БД в Yandex Cloud](#task4-1)
* [Задание 5*](#задание-5)
* [LICENSE](#license)

## Задание 1
<a id="task1-1"></a>
> Создайте Virtual Private Cloud (VPC)
> 
> Создайте подсети.

В проекте модуль `vpc_dev`:
```yaml
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.141.0"
    }
  }
  required_version = "~>1.9"
}

resource "yandex_vpc_network" "finalter" {
  name = var.env_name
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "sub_finalter" {
  for_each = { for i, s in var.subnets: i => s }
  name = "${var.env_name}-${each.value.zone}"
  zone = each.value.zone
  folder_id = var.folder_id
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.finalter.id
}
```
<a id="task1-2"></a>
> Создайте виртуальные машины (VM)
> 
> Привяжите группу безопасности к VM
В проекте модуль `vm_create`:
```yaml
data "yandex_compute_image" "my_image" {
  family = var.image_family
}

resource "yandex_compute_instance" "vm" {
  count = var.instance_count

  name               = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"
  platform_id        = var.platform
  hostname           = var.env_name == null ? "${var.instance_name}-${count.index}" : "${var.env_name}-${var.instance_name}-${count.index}"
  zone               = element(var.subnet_zones, count.index)
  service_account_id = var.service_account_id
  description        = "${var.description} {{terraform managed}}"
  scheduling_policy {
    preemptible = var.preemptible
  }
  
  resources {
    cores         = var.instance_cores
    memory        = var.instance_memory
    core_fraction = var.instance_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.image_id
      type     = var.boot_disk_type
      size     = var.boot_disk_size
    }
  }

  network_interface {
    subnet_id  = element(var.subnet_ids, count.index)
    nat        = var.public_ip
    ip_address = var.known_internal_ip
    security_group_ids = [yandex_vpc_security_group.lns.id]
  }

  metadata = {
    for k, v in var.metadata : k => v
  }
  
  labels = {
    for k, v in local.labels : k => v
  }

  allow_stopping_for_update = true

  lifecycle {
    ignore_changes = [
      boot_disk,
    ]
  }
}
```
<a id="task1-3"></a>
> Настройте группы безопасности (порты 22, 80, 443)
>
> Привяжите группу безопасности к VM
```yaml
resource "yandex_vpc_security_group" "lns" {
  name       = "lns_ter_dynamic"
  network_id = var.yandex_vpc_network_finalter_id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
```
<a id="task1-4"></a>
> Опишите создание БД MySQL в Yandex Cloud
В проекте модуль `ydb_dev`:
```yaml
resource "yandex_ydb_database_serverless" "lns_ydb" {
  name      = "tfstate-lock-lns"
  folder_id = var.folder_id
  location_id = "ru-central1"

  deletion_protection = false
}

resource "yandex_ydb_database_iam_binding" "editor" {
  database_id = yandex_ydb_database_serverless.lns_ydb.id
  role        = "ydb.editor"

  members = [
    "serviceAccount:ajed6hclf66f9k40qmij",
  ]
}

resource "yandex_ydb_table" "lns_table" {
  path              = "tfstate-lock"
  connection_string = yandex_ydb_database_serverless.lns_ydb.ydb_full_endpoint

  column {
    name     = "LockID"
    type     = "Utf8"
    not_null = true
  }

  primary_key = ["LockID"]
}
```

Результат:

![image](https://github.com/user-attachments/assets/f8159013-60e1-4848-8a46-f03808bc1975)

![image](https://github.com/user-attachments/assets/faf08b8a-343d-464b-b59f-36d92eae0d9f)

![image](https://github.com/user-attachments/assets/574cefb1-2d0a-4a23-9984-71c475973636)

![image](https://github.com/user-attachments/assets/f537cac7-4a99-44f3-bea2-2e23bfbbadca)

<a id="task1-5"></a>
> Опишите создание Container Registry
В проекте модуль `container_registry`:
```yaml
# Создание сервисного аккаунта
resource "yandex_iam_service_account" "cr-user" {
  name = var.cr_user_conf.name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "cr-role" {
  folder_id = var.folder_id
  role      = var.cr_user_conf.role
  member    = "serviceAccount:${yandex_iam_service_account.cr-user.id}"
}

resource "yandex_container_registry" "cr-registry" {
  folder_id = var.folder_id
  name      = var.cr_conf.registry_name
}

resource "yandex_container_registry_iam_binding" "editor" {
  registry_id = yandex_container_registry.cr-registry.id
  role        = var.cr_conf.role

  members = [
    "serviceAccount:${yandex_iam_service_account.cr-user.id}",
  ]
}
```

Результат:

![image](https://github.com/user-attachments/assets/40f2af25-8d2b-4558-8ff0-315ade58032a)

## Задание 2
<a id="task2-1"></a>
> Используя user-data (cloud-init), установите Docker и Docker Compose

Файл `cloud-init.yml`
```yaml
#cloud-config
groups:
  - docker

ssh_pwauth: no
users:
  - name: ${ssh_name}
    groups: 
    - sudo
    - docker
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${ssh_public_key}
package_update: true
package_upgrade: false
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg-agent
  - software-properties-common

# Устанавливаем docker и запускаем контейнер
runcmd:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - apt-get update -y
  - apt-get install -y docker-ce docker-ce-cli containerd.io
  - systemctl start docker
  - systemctl enable docker

```

Результат:

![image](https://github.com/user-attachments/assets/ac672335-dafb-4a99-ad4b-2b80fd2f0af7)

## Задание 3
<a id="task3-1"></a>
> Опишите Docker файл c web-приложением и сохраните контейнер в Container Registry

Приложение хранится в папке [./dockercompose](https://github.com/NikitaLGit/devops-ntlg-lns/tree/tftask4/terraform/final_terraform/dockercompose)

`compsoe.yaml` файл (удален блок с сервисом `db`. Информация хранится в базе данных кластера `MYSQL` от `YC` из [Задания 4](#задание-4) ):
```yaml
include:
  - proxy.yaml

version: "3"

x-deploy: &deploy-dev
  deploy:
    resources:
      limits:
        cpus: "1"
        memory: 512M
      reservations:
        memory: 256M
x-env_file: &env_file
  env_file:
    - .env

services:
  web:
    <<: [*deploy-dev, *env_file]
    build:
      dockerfile: Dockerfile.python
    image: web_app:latest
    networks:
      backend:
        ipv4_address: 172.20.0.5
    environment:
      - DB_NAME=${MYSQL_DATABASE}
      - DB_TABLE=${MYSQL_TABLE}
      - DB_PASSWORD=${MYSQL_PASSWORD}
      - DB_USER=${MYSQL_USER}
      - DB_HOST=${MYSQL_HOST}
    ports:
      - "5000:5000"
    restart: always

networks:
  backend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

Данные бурется из файла `.env` типа:
```yaml
MYSQL_DATABASE      ="db1"
MYSQL_TABLE         ="table1"
MYSQL_USER          ="nikitaleonov"
MYSQL_PASSWORD      ="12345678"
MYSQL_HOST          ="rc1b-*****************.mdb.yandexcloud.net"
MYSQL_PORT          ="3306"
```
<a id="task3-2"></a>
Теперь сохраним 3 образа для приложения в `container registry`

```bash
docker commit dockercompose-ingress-proxy-1
```
> sha256:e160fb240008140d66d50ac42a5f00d688c41a313aeb11c6492ad05acacc5f03
```bash
docker tag e160fb2400081 cr.yandex/crpokal510*******/ing_proxy_final
```
```bash
docker push cr.yandex/crpokal510*******/ing_proxy_final
```
Имеем 3 образа для пуша в `YC`

![image](https://github.com/user-attachments/assets/16144699-dbc9-4208-bbf2-9cf5bc37fc30)

После пуша в `container registry` видим 3 папки с `image`

![image](https://github.com/user-attachments/assets/41b28006-85cc-4318-b8d9-00e63e2859fd)

## Задание 4
<a id="task4-1"></a>

Запустим 3 контейнера приложения из предыдущих заданий.

![image](https://github.com/user-attachments/assets/83d0021b-61da-4e60-8038-84f7caa162dc)

В `YC` видим, что `MYSQL cluster` успешно собрался и с ним можно работать

![image](https://github.com/user-attachments/assets/fc762974-abaa-415a-a338-506a8f81e97a)

![image](https://github.com/user-attachments/assets/2e3bafd3-83f4-460d-840b-994cef6ecd1f)

По инструкции подключимся к хосту и увидим, что данные записываются в таблицу

![image](https://github.com/user-attachments/assets/e619cbee-638b-4511-85ef-4ba42ae45647)

## Задание 5*

На данный момент ничего. Не успеваю

## License

This project is licensed under the MIT License (see the `LICENSE` file for details).
