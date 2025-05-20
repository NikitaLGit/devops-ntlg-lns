## main.tf

Вызов модуля `vpc_dev`
Вызов модуля `vm_create`
Data файла `cloud-init.yml` в vm из модуля `vm_create`

## Модуль vm_create

создание 2х вм:
finalter-web-0
finalter-web-1

Вход по ssh

## Модуль vpc_dev
создание сети `finalter`

Трех подсетей
```yaml
{ zone = "ru-central1-a", cidr = "10.0.10.0/24" }
{ zone = "ru-central1-b", cidr = "10.0.20.0/24" }
{ zone = "ru-central1-d", cidr = "10.0.30.0/24" }
```

