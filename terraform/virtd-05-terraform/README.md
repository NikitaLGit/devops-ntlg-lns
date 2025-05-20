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
## Задание 4
## Задание 5
## Задание 6
## Задание 7
