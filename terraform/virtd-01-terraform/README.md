пордготовка

скачали терраформ версии 1.9.8
докер есть
сделали форк репозитория

ЗАДАНИЕ 1

1. Выполним terraform init в папке /src
2. хранить файлы можно в файле personal.auto.tfvars
3. выполним код прописав terraform apply
в паоявившемся файле terraform.tfstate результат всех операций. найдем в

"resources": 
    "instances": 
         "result": "TAB7M4MQCAlqmm2z"

4. в ресурсе с типом "docker_image" должен быть label. добавим его "nginx"
resource "docker_image" "nginx" {

в ресурсе "docker_container" был неправильынй label. изменим с "1nginx" на "nginx"
resource "docker_container" "nginx" {

в name ресурса "docker_container" ошибки. поправим
name  = "example_${random_password.random_string.result}"

после поправок запустим terraform validate и получик инфу, что все ок
