## Задания 1-8

Создано 3 репозитория для 3х ролей. Все сделано как надо. Выданы теги `v1.0.0`:
* https://github.com/NikitaLGit/clickhouse-role
* https://github.com/NikitaLGit/vector-role
* https://github.com/NikitaLGit/loghthouse-role

## Задания 9-11

Скачаем роли.
Файл `requirements.yml`
```yaml
---
- name: clickhouse
  src: git@github.com:NikitaLGit/clickhouse-role.git
  scm: git
  version: v1.0.1

- name: vector
  src: git@github.com:NikitaLGit/vector-role.git
  scm: git
  version: v1.0.0

- name: lighthouse
  src: git@github.com:NikitaLGit/lighthouse-role.git
  scm: git
  version: v1.0.0
```

Переработаем palybook:
```yaml
---
- name: Install Clickhouse
  hosts: clickhouse
  gather_facts: false
  roles: 
    - clickhouse

- name: Install Vector
  hosts: vector
  gather_facts: false
  roles: 
    - vector

- name: Install Lighthouse
  hosts: lighthouse
  gather_facts: false
  roles: 
    - lighthouse
```

В `YC` имеем три машины:

![image](https://github.com/user-attachments/assets/86e7ec0e-5539-49e0-8a8a-4c59b62915d0)

Запустим измененный `playbook`:

![image](https://github.com/user-attachments/assets/79fcc59c-84fa-41d3-850b-36c396f4a8f0)

Зайдем на порт `80` хоста с l`ighthouse` на котором слушается `nginx`:

![image](https://github.com/user-attachments/assets/464c0f91-61e4-4a2a-bb02-a27e53818088)

И на порт `8080`, где лежит `lighthouse` и получим доступ к самому `lighthouse`:

![image](https://github.com/user-attachments/assets/af965cc2-1013-478f-a689-20fdd3f39dce)

Все работает.
