## Задача 1

Поднимем 1 сервер `manager` и 2 `worker` на базе `ubuntu 24.04 lts`:
![image](https://github.com/user-attachments/assets/509010da-5a0f-4122-b369-6a96d0c53373)

Установим везде `docker`, написав простой скрипт:
```bash
#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Теперь получим IP внутренней сети в `YC`:

![image](https://github.com/user-attachments/assets/02e9954a-6d38-4673-98af-d537a42d813c)

Введем команду инициализации `docker swarm`:

![image](https://github.com/user-attachments/assets/f40ae5bb-5960-4385-9eeb-9bcba6f7d5bb)

На `worker`-ах введем предложенную команду. Получим:

![image](https://github.com/user-attachments/assets/a9612487-db25-462d-9508-5deda9097290)

## Задача 2

Пока ничего. позже дополню

## Задача 3

Аналогично Задаче 2
