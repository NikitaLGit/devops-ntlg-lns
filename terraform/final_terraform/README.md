## main.tf

* Вызов модуля `vpc_dev`
* Вызов модуля `vm_create`
* Вызов модуля `mysql_cluster`
* Вызов модуля `s3bucket`
* Вызов модуля `ydb_dev`
* Data файла `cloud-init.yml` в vm из модуля `vm_create`

## Модуль vm_create

создание вм:
`finalter-web-0`

Вход по ssh

## Модуль vpc_dev
создание сети `finalter`

и подсети
```yaml
{ zone = "ru-central1-a", cidr = "10.0.10.0/24" }
```

## Модуль mysql_cluster

Создание кластера mysql с именем `mysql-clstr-lns`
Базы данных в кластере `mysql-db-lns`
Пользователя кластера с полными правами `cluster-admin-lns`

## Модуль s3bucket

Создание сервисного аккаунта `s3admin` с парвами `storage.admin`
создание бакета `lns-bucket-final`

## Модуль ydb_dev

Создание базы данных `tfstate-lock`
сервисному аккаунту `tfstate` сделанному руками выдаются права editor
создается таблица `tfstate-lock-lns` с колонкой `LockID`

## Папка dockercompose

Докер файл и все нужное для 4х контейнеров веб приложения из ранних заданий
