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
Файл (`terraform_docs.md`) получился, но не такой красивый, как на скриншотах:

![image](https://github.com/user-attachments/assets/8fb12d61-ea40-42bb-9a0c-1b40cd27fba0)

## Задание 3

Выведем список ресурсов в state

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
## Задание 5
## Задание 6
## Задание 7
## Задание 8
