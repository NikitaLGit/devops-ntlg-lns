## Задание 1

Поднимем контейнеры:

![image](https://github.com/user-attachments/assets/6dcca640-d2c9-4b8d-a220-80ee51336b1a)

Зайдем в `web grafana`

![image](https://github.com/user-attachments/assets/812540b9-b5b9-4941-9f8d-e92098113a4b)

Добавим `prometheus` в `data sources`

![image](https://github.com/user-attachments/assets/f18a16fd-a211-4348-a6c9-3351c6cfab30)

> [!WARNING]
> Если указать `localhost` или `prometheus`, то сервер будет выдвать ошибку `http bad request`.

Вместо этого задаем `ip локальный` контейнера с `prometheus`
```bash
docker inspect prometheus
```

![image](https://github.com/user-attachments/assets/104d1560-6c12-42be-a120-2a9b94208168)

Прописав этот адрсе и выбрав `http method` — `GET` получим верный вывод:

![image](https://github.com/user-attachments/assets/f4fef93c-a570-4c9f-86f1-6da046fb76cb)

## Задание 2

> Утилизация CPU для nodeexporter (в процентах, 100-idle)
```bash
100 - avg(irate(node_cpu_seconds_total{job="nodeexporter", mode="idle"}[1m])) * 100
```

![image](https://github.com/user-attachments/assets/ceb1da36-e0a3-4d9f-8ec9-28a522025894)

> CPULA 1/5/15
```bash
avg(node_load1{job="nodeexporter"})
```
```bash
avg(node_load5{job="nodeexporter"})
```
```bash
avg(node_load15{job="nodeexporter"})
```

![image](https://github.com/user-attachments/assets/ea8a5ed4-721d-42c5-9cef-c030c09a4bee)

> Количество свободной оперативной памяти
```bash
node_memory_MemFree_bytes{job="nodeexporter"}
```

![image](https://github.com/user-attachments/assets/8d2adef4-b894-4689-9bd3-bd10e499745f)

> Количество места на файловой системе
```bash
node_filesystem_avail_bytes{fstype=~"ext4|xfs"}
```
```bash
node_filesystem_size_bytes{fstype=~"ext4|xfs"}
```

![image](https://github.com/user-attachments/assets/4e802ad5-5b9c-4b06-bd74-0b34ddda7471)

Общий вид `dashboard`

![image](https://github.com/user-attachments/assets/bf928f5c-dd47-4199-a08e-e6ca026f43e6)

## Задание 3

Добавим в список `Contact points` нашу группу телеграмм, где есть мы и ранее созданный `бот`

![image](https://github.com/user-attachments/assets/2e084b2b-5917-4936-abe3-53ee40325b38)

Создадим `alert` на свобоную оперативную память. Для теста поставим `alert` на значени больше `85 мегабайт` ( при среднем значении 82). Данные букдут отпарвляться в группу телеграмм

![image](https://github.com/user-attachments/assets/07f89c55-fcba-47b3-8c24-c8a070e72977)

![image](https://github.com/user-attachments/assets/313bf56d-da2f-4eaa-b03c-3b8c54c4a21b)

Освободим память

![image](https://github.com/user-attachments/assets/22ad814e-ec1f-4d78-b279-1f510cdc9d8a)

И получим оповещение в группу (правда не очень красивое)

![image](https://github.com/user-attachments/assets/e18af313-d31a-46c3-a1a6-189775013e9c)

## Задание 4

файл `json` лежит рядом - [netology_03_01072025.json](https://github.com/NikitaLGit/devops-ntlg-lns/blob/main/monitoring/mntr-03-grafana/netology_03_01072025.json)
