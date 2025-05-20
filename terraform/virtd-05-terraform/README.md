Проверим версию терраформ

![image](https://github.com/user-attachments/assets/16a66e6b-e416-41ef-ac33-06974f87c86c)

## Задание 1

Создадим ветку `terraform-05`. В ней папка `virtd/virtd-05-terraform`. Вставим требуемый код:

![image](https://github.com/user-attachments/assets/2704ed7d-4388-4afa-b246-470f29ab6f70)

Запустим проверку `tflint` согласно инструкции на оф странице проекта - https://github.com/terraform-linters/tflint, в виде контейнера:
```bash
docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint
```

Получаем следующие ошибки:
```yaml
4 issue(s) found:

Warning: Missing version constraint for provider "yandex" in `required_providers` (terraform_required_providers)

  on providers.tf line 3:
   3:     yandex = {
   4:       source = "yandex-cloud/yandex"
   5:     }

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.12.0/docs/rules/terraform_required_providers.md

Warning: [Fixable] variable "vms_ssh_root_key" is declared but not used (terraform_unused_declarations)

  on variables.tf line 36:
  36: variable "vms_ssh_root_key" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.12.0/docs/rules/terraform_unused_declarations.md

Warning: [Fixable] variable "vm_web_name" is declared but not used (terraform_unused_declarations)

  on variables.tf line 43:
  43: variable "vm_web_name" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.12.0/docs/rules/terraform_unused_declarations.md

Warning: [Fixable] variable "vm_db_name" is declared but not used (terraform_unused_declarations)

  on variables.tf line 50:
  50: variable "vm_db_name" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.12.0/docs/rules/terraform_unused_declarations.md
```
Типы ошибок:
1. в провайдере не указана требуемая версия;
2. объявлена переменная `vms_ssh_root_key`, но она нигде не используется;
3. объявлена переменная `vm_web_name`, но она нигде не используется;
4. объявлена переменная `vm_db_name`, но она нигде не используется.

Теперь проверим `checkov`:
```bash
docker run --rm -v ${PWD}:/tf bridgecrew/checkov -d /tf
```

Получаем так же 4 ошибки, но другие:

![image](https://github.com/user-attachments/assets/7f2ad5d1-4e61-46a5-af4a-c5d18e428e8f)

2 типа ошибок (по 2 на каждый ресурс создания вм)
Check: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
> не совсем понятно что за ошибка. Пишут вообще, что это ошибка `checkov` и нужно понизить его версию. При чем тут это?
> 
Check: CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
> тут пишут про то, что указана явно ветка `main` То есть лучше без указания ветки?

## Задание 2

Ветку уже создал. Проверим

![image](https://github.com/user-attachments/assets/893daf4f-1b97-4b09-9c2e-a537086ee97a)

Теперь повторим демонстрацию и настроим бакет, сервисный акканут, а так же создадим базу данных.
Создадим сервисный акканут `tfstate`:

![image](https://github.com/user-attachments/assets/079fc0d0-7e6c-48c3-970d-cbb9122d2447)

Для аккаунта создадим статический ключ доступа и запишем его.

Создадим новый бакет `tfstate-lns-1`:

![image](https://github.com/user-attachments/assets/06a6e996-8bcd-461a-b295-829468da788c)

Создадим базу данных `YDB` и в ней таблицу `tfstate-lock`:

![image](https://github.com/user-attachments/assets/08683091-690f-4faa-ba1d-6a9fe84092e0)

В папке проекта запустим
```bash
terraform apply
```

получаем файл `terraform.tfstate`

![image](https://github.com/user-attachments/assets/01ebb1d8-0799-437a-b7c9-c4a1ec97944b)

Теперь перенесем этот файл в `s3bucket` созданный ранее.
В объявление terraform вставим `backend “s3”`:

```yaml
backend "s3" {
  endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "tfstate-lns-1"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенsда для Terraform версии 1.6.3 и старше.
  }
}
```

Введем следующее
```bash
terraform init -backend-config="access_key=YCAJE6DAKLu*****************" -backend-config="secret_key=YCNlI_uHZgajO24lSv**********************"
```

Подтверждаем.

![image](https://github.com/user-attachments/assets/7cdae94d-b3f0-4635-9074-7d8e6dd41a28)

Файл `terraform.tfstate` теперь пустой:

![image](https://github.com/user-attachments/assets/0d591f2e-7e1e-45d7-baeb-44d929a76210)

В нашем бакете видим файл стейта:

![image](https://github.com/user-attachments/assets/512573ff-7c08-4948-8970-4f21e5b9ff4f)

Получив ссылку можно проверить, что верно перенеслось состояние.

Закоммитим все в ветку `terraform-05`:

![image](https://github.com/user-attachments/assets/aa03bb74-05ce-4d98-9b8a-2c225547939e)

Теперь в `backend` добавим параметры базы данных которую создали ранее
```yaml
dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gv70mvh8quh0edjcqr/etndujbvilthn7u74v52"
dynamodb_table = "tfstate-lock"
```

Запустим

```bash
terraform init -backend-config="access_key=YCAJE6DAKLu*****************" -backend-config="secret_key=YCNlI_uHZgajO24lSv**********************" -migrate-state
```

в таблице базы появилась запись:

![image](https://github.com/user-attachments/assets/6da1debf-46b4-463e-a50d-0d549ced11f7)

Зайдем в консоль. Параллельно запустим `terraform plan`. Получим ошибку:

![image](https://github.com/user-attachments/assets/301211b7-3385-417f-a756-3175227bc74f)

Разблокируем стейт командой:

![image](https://github.com/user-attachments/assets/fed04358-4d8e-4782-a305-78a6d94be8dd)

После чего теперь можем выполнить `terraform plan`.

## Задание 3

Создадим новую ветку `terraform-hotfix` из ветки `terraform-05`:

![image](https://github.com/user-attachments/assets/e8ce1b50-993f-4dfe-96fd-1d5a54d91d02)

Проверим `tflick`:
> Добавим в провайдера яндекс `требования к версии`, а так же удалим объявление `неиспользуемых переменных`. Ошибка пропадет.

![image](https://github.com/user-attachments/assets/f0c32572-3887-4a08-b4c6-e24c7ba196cf)

Теперь проверим `checkov`:
Выдвет ошибки из `Задания 1`.
> [!WARNING]
> Я не понимаю, почему их 4 и что это за ошибки. Инфы никакой не нашел.
> 
> При запуске `checkov`
> 
> ```bash
> docker run --rm -v ${PWD}:/tf bridgecrew/checkov -d /tf
> ```
> 
> Выдает кучу ошибок и потом проверку. Полный лог привел в файле `checkov.md`

Отправим `pull request` - [Ссылка на request](https://github.com/NikitaLGit/devops-ntlg-lns/pull/1)

## Задание 4

Перепишем файл `variables.tf` и в кажой переменной вставим проверку:
```yaml
###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
  sensitive = true
  validation {
    condition = length(var.token) >= 32
    error_message = "Must be at least 32 character long API token."
  }
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive = true
  validation {
    condition = length(var.cloud_id) == 20
    error_message = "cloud_id var must be 20 character long"
  }
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  sensitive = true
  validation {
    condition = length(var.folder_id) == 20
    error_message = "folder_id var must be 20 character long"
  }
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
  validation {
    condition = contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], var.default_zone)
    error_message = "Wrong type of zone. Must be 'ru-central1-{a/b/c}'"
  }
}
variable "default_cidr" {
  type        = set(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  validation {
    condition = alltrue([
      for a in var. default_cidr: can(cidrnetmask(a))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
  validation {
    condition = length(var.vpc_name) >= 3
    error_message = "vpc_name var must be 3 or more character long"
  }
}
```

Проверим верность. Не понял как проверить переменную через консоль. Она же задается перед `terraform apply`? Буду делать через конструкцию `terraform plan -var=""`

`var.token`:

![image](https://github.com/user-attachments/assets/1cca0431-80c7-4961-8a36-a01adb825a4a)

`var.cloud_id`:

![image](https://github.com/user-attachments/assets/fe695d2a-48d7-4008-baa8-3121e6266b92)

`var.default_zone`:

![image](https://github.com/user-attachments/assets/09536646-1bcc-40c0-b635-7481f9210f0d)

`var.defautl_cidr. Один ip address {С УКАЗАНИЕМ МАСКИ, БЕЗ НЕЕ ВСЕГДА ОШИБКА СООТВЕТСТВИЯ}`:

![image](https://github.com/user-attachments/assets/c5f0f899-6318-4298-b091-48524ef94ed9)

![image](https://github.com/user-attachments/assets/7cef07df-9702-4674-926a-29138c9f4077)

`var.defautl_cidr. Несколько ip address`:

![image](https://github.com/user-attachments/assets/66cf3583-ca03-47cb-818c-9fdb5762de98)

## Задание 5

Создадим файл `task5.tf`. В нем пропишем 2 переменные для задания:

```yaml
variable "lowercase_string" {
  type = string
  default = "default string"

  validation {
    condition = lower(var.lowercase_string) == var.lowercase_string
    error_message = "String must be only lowercase!"
  }
}
```

Проверим:

![image](https://github.com/user-attachments/assets/28379c72-5a39-4675-b267-ef04b09c6f2e)

Теперь напишем переменную для второй части задания:

```yaml
variable "onlyonebool" {
  type = object({
    bool_a = bool
    bool_b = bool 
  })
  default = {
    bool_a = false
    bool_b = false
  }

  validation {
    condition = (
        (var.onlyonebool.bool_a && !var.onlyonebool.bool_b) ||
        (!var.onlyonebool.bool_a && var.onlyonebool.bool_b)
    )
    error_message = "must be only one true and one false"
  }
}
```

![image](https://github.com/user-attachments/assets/c0f2366e-bde5-40c1-9b5a-6388ce40127e)

## Задание 6

пока нет

## Задание 7

Так и не понял что значит разделить `root модуль`. Сделал отдельный файл `task7.tf`:

```yaml
# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = var.s3_conf.service_name
  description = "test account for task 7"
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
  grant {
    id          = yandex_iam_service_account.sa.id
    type        = var.s3_conf.type
    permissions = [var.s3_conf.permissions]
  }
  anonymous_access_flags {
    read        = var.s3_conf.flags_read
    list        = var.s3_conf.flags_list
    config_read = var.s3_conf.flags_config_read
  }
  tags = {
    test7key = "test7value"
  }

  force_destroy = var.s3_conf.force_destroy
}

# Создание базы данных
resource "yandex_ydb_database_serverless" "database1" {
  name                = var.ydb_conf.name
  folder_id = var.folder_id
  deletion_protection = var.ydb_conf.deletion_protection
  location_id = var.ydb_conf.location_id

  serverless_database {
    enable_throttling_rcu_limit = var.ydb_conf.enable_throttling_rcu_limit
    provisioned_rcu_limit       = var.ydb_conf.provisioned_rcu_limit
    storage_size_limit          = var.ydb_conf.storage_size_limit
    throttling_rcu_limit        = var.ydb_conf.throttling_rcu_limit
  }
  labels = {
    test7 = "test7"
  }
}
```

Переменные:

```yaml
variable "s3_conf" {
  type = map(any)
  default = {
    service_name = "s3task7"
    sa_role      = "storage.admin"
    name         = "netology-lns-s3-task7"
    size         = 1073741824
    storage_class = "standard"
    flags_read        = false
    flags_list        = false
    flags_config_read = false
    force_destroy    = false
    type        = "CanonicalUser"
    permissions = "FULL_CONTROL"
  }
}

variable "ydb_conf" {
  type = map(any)
  default = {
    name                = "test-sl-task7"
    deletion_protection = false
    location_id = "ru-central1"
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 1
    throttling_rcu_limit        = 0
  }
}
```

Запустим `terraform apply`

Теперь у нас есть новый `сервисный аккаунт`:

![image](https://github.com/user-attachments/assets/15564413-60c9-4ca9-b984-98386e3b6dec)

Новый `s3backet` в котором есть добавленный новый сервисный аккаунт:

![image](https://github.com/user-attachments/assets/e52438ee-3f27-42d4-9607-7099c2f9ffed)

И новая `база данных`:

![image](https://github.com/user-attachments/assets/dcb8dec6-c87e-4f62-bf62-d28f278d0cb2)
