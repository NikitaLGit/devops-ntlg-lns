## Задача 1. Ответ
https://hub.docker.com/repository/docker/nleonovg/custom-nginx/general

## Задача 2. Ответ
![custom-nginx](https://github.com/user-attachments/assets/0bad8a6c-b948-4e19-aaa1-e49e1e81473b?raw=true)

## Задача 3. Ответ
> [!WARNING]
> <kbd>Ctrl</kbd>+<kbd>C</kbd> прерывает процесс. Поэтому передав команду на ввод контейнера, мы его прервали (остановили)

![nginxwork](https://github.com/user-attachments/assets/e9f31ead-be83-438f-aff4-0995b811e874?raw=true)

* Мы перевели nginx с 80 порта на 81. Теперь он живет там. Поэтому при обращении на 80 порт контейнера будет выдаваться ошибка.

* Чтобы поменять проброс портов с хоста на другой порт контейнера, нужно выключить контейнер, остановить сервисы docker ( + docker.socket ) и зайти в папку контейнера, где содержатся все его файлы по пути `/var/lib/docker/containers/<ID>/`. Там, в файле `hostconfig.json` ищем строку `"PortBindings":{"80/tcp":[{"HostIp":"127.0.0.1","HostPort":"8080"}]}`. Меняем порт контейнера с 80 на 81.
В той же папке контейнера редактируем файл `./config.v2.json`. Ищем строку `"ExposedPorts":{"80/tcp":{},"8080/tcp":{}}`. Можем заменить с 80 на 81, а можем записать еще один порт на прослушку `"ExposedPorts":{"80/tcp":{},"81/tcp":{},"8080/tcp":{}}`

![port80to81](https://github.com/user-attachments/assets/df7b91af-1afe-45d8-a956-4f86d0af9c51?raw=true)

* Чтобы удалить контейнер не останавливая его нужно для команды rm добавить ключ -f: `docker rm -f <container>`

## Задача 4. Ответ
* Создадим 2 машины: ubuntu (image centos ни в какую не хочет загружаться в docker) и debian:

![ubuntudebian](https://github.com/user-attachments/assets/0729b367-de70-4da1-9104-df761afa0842?raw=true)

![filesdata](https://github.com/user-attachments/assets/bd9094a6-9709-40e8-9518-65c06c6ea154?raw=true)

## Задача 5. Ответ
* При запуске
```bash
docker-compose up -d
```
docker-compose ищет файлы по типу 
- `compose.yaml (приоритет)`,
- `compose.yml`,
- `docker-compose.yaml`,
- `docker-compose.yml`.

Найдя первое соответствие, он запускает процесс. В моем случае это файл `docker-compose.yaml`. в документации указано, что `compose.yaml` является приоритетным, но, видимо, только как рекомендация, поскольку `docker-compose.yaml` более устаревший формат.

![compose](https://github.com/user-attachments/assets/10574506-2bfa-4499-91bc-a131c80a7866?raw=true)

> [!TIP]
> `include` не работал никак. Выдавал ошибку `ERROR: The Compose file './compose.yaml' is invalid because:
Unsupported config option for services.registry: 'extend'`

* Внесем изменения в файл `compose.yaml`

![compose](https://github.com/user-attachments/assets/6e3b7de7-f90d-48c3-a92d-6b5e721fa95a?raw=true)

![dockercompose](https://github.com/user-attachments/assets/434224b8-03e9-45d5-89f2-a3f6b25ae691?raw=true)

* Заливаем образ `nleonovg/custom-nginx` как `custom-nginx:latest` в запущенное локальное registry:

![customn](https://github.com/user-attachments/assets/eb603249-97d1-4c80-9ae9-891664f63b37?raw=true)

![push](https://github.com/user-attachments/assets/4f74a581-00df-4b16-9591-ed7766ddfc04?raw=true)

> [!WARNING]
> Откуда взялся порт 9000? 

Пропишем `ports: "9000:9000"` в файл `compose.yaml`. Так же удалим параметр `network_mode: host`, который все еще есть в репозитории, хотя он вызывает ошибку! (почему так?)

* Настроим пароль и войдем в `http://host:9000/#!/home`

![pointer](https://github.com/user-attachments/assets/36ad79bf-873f-4073-a77e-681294c4242d?raw=true)

* Зайдем в stack - web editor:

![image](https://github.com/user-attachments/assets/35ae843b-70ae-4c8a-aa74-e7bf6aece316?raw=true)

* Перейдем в `http://host:9000/#!/3/docker/containers` и найдем `inspect` (i):

![inspect](https://github.com/user-attachments/assets/964fe6e3-e777-4eb2-aec3-ad81fa07bf1e?raw=true)
![inspect2](https://github.com/user-attachments/assets/e810e42f-ccb7-40db-a64e-9139497a4220?raw=true)

![containers](https://github.com/user-attachments/assets/c38682ae-b303-414c-957d-85a98d8ad36a?raw=true)

* Удалим `compose.yaml`

![deletecompose](https://github.com/user-attachments/assets/52ab6911-1877-480b-8891-9a9197b53903?raw=true)

* Остановим все контейнеры одной командой:

![stopall](https://github.com/user-attachments/assets/e0a89a81-2c68-41de-9849-420bc63afaf2?raw=true)
