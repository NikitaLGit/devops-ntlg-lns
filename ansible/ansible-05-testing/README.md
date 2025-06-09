## Подготовка

Все установлено:

![image](https://github.com/user-attachments/assets/b8415327-a969-431f-ade3-430917a39bb7)

Старый образ очередной (хотя заявляется актуализация каждые `пол года` при покупке курса)

## Molecule
### Задание 1

Инициализируем папку молекулы в vector роли
```bash
molecule init scenario vector
```

Получим структуру
```bash
.
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── LICENSE
├── meta
│   └── main.yml
├── molecule
│   └── default
│       ├── converge.yml
│       ├── molecule.yml
│       └── prepare.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
│   └── vector.yaml.j2
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

Сначала добавим в файл meta/main.yml
```yaml
galaxy_info:
  role_name: vector
  namespace: lns
...
```

converge.yml:
```yaml
---
- name: Converge
  hosts: all
  gather_facts: false
  become: true
  tasks:
    - name: "Include vector"
      include_role:
        name: "/home/lns/git_devops/ansible_roles/vector"
```

molecule.yml:
```yaml
---
driver:
  name: docker
platforms:
  - name: ubuntu2404
    image: docker.io/geerlingguy/docker-ubuntu2404-ansible
  # - name: oracle
  #   image: docker.io/oraclelinux:8
    pre_build_image: true
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    capabilities:
      - SYS_ADMIN
    privileged: true
provisioner:
  name: ansible
verifier:
  name: ansible
lint: |
  set -e
  yamllint .
  ansible-lint .
scenario:
  test_sequence:
    - dependency
    # - lint
    - cleanup
    - destroy
    - syntax
    - create
    - prepare
    - converge
    - idempotence
    - side_effect
    - verify
    - cleanup
    # - destroy
```

prepare.yml:
```yaml
---
- name: prepare
  hosts: all
  gather_facts: false
  become: true
  vars:
    run_in_container: true
  tasks:
    - name: Update apt cache
      ansible.builtin.apt:
        update_cache: true
    - name: Install common utils
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      with_items:
        - net-tools
        - htop
```

Запустим `molecule converge`. Все ставится, только не может отработать блок рестарта сервиса из handlers. Постоянно выдает ошибку ниже. Ничего не помогает:
```bash
TASK [/home/lns/git_devops/ansible_roles/vector : Vector | Create Vector data_dir] ***
ok: [ubuntu2404]

RUNNING HANDLER [/home/lns/git_devops/ansible_roles/vector : Vector | Start Vector service] ***
fatal: [ubuntu2404]: FAILED! => {"changed": false, "msg": "failure 1 during daemon-reload: System has not been booted with systemd as init system (PID 1). Can't operate.\nFailed to connect to bus: Host is down\n"}

PLAY RECAP *********************************************************************
ubuntu2404                 : ok=12   changed=6    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ansible-playbook --inventory /home/lns/.ansible/tmp/molecule.sNUc.default/inventory --skip-tags molecule-notest,notest /home/lns/git_devops/ansible_roles/vector/molecule/default/converge.yml
(reverse-i-search)`molecule': cd /home/lns/git_devops/ansible_roles/clickhouse && mkdir -p molecule/default/roles && ln -sf ../../../clickhouse ^Clecule
/default/roles/clickhouse
```

![image](https://github.com/user-attachments/assets/e3518a5d-f20f-4606-bdca-e285e22c3061)

![image](https://github.com/user-attachments/assets/4b09c892-baa9-485b-8884-794f420a3853)

> [!WARNING]
> `lint` так же не работает. Пишет не находит команду `lint` при запуске `molecule lint`. Поставил и `yamllint` и `ansible-lint`
> 
> UPDATE:
> 
> А его нет, потому что все опять устарело и в командах молекулы нет `lint`:
> 
> ![image](https://github.com/user-attachments/assets/fb5d1cae-65ea-44e0-b0f5-2362df6106a1)

Допишем файл `verify.yml`
```yaml
---
- name: Verify
  hosts: all
  gather_facts: false

  tasks:
    - name: Get Vector version
      ansible.builtin.command: vector --version
      changed_when: false
      register: vector_version
      failed_when: vector_version.rc != 0

    - name: Vector version ouput
      ansible.builtin.debug:
        var: vector_version.stdout

    - name: Validation Vector configuration
      ansible.builtin.command: vector validate --no-environment --config-yaml /etc/vector/vector.yaml
      changed_when: false
      register: vector_validate
      failed_when: vector_validate.rc != 0

    - name: Vector configuration ouput
      ansible.builtin.debug:
        var: vector_validate.stdout
```

При тестировнии получаем:

![image](https://github.com/user-attachments/assets/9901a775-55e6-43fa-a0d5-90b8f922d830)

> [!TIP]
> [Ссылка на релиз с заданием molecule](https://github.com/NikitaLGit/vector-role/releases/tag/v1.0.1)

## TOX
> ### В очередной раз ничего не понятно, что требуется.
> #### Почему в уроке запускаем на локальной машине, а тут просят на старом образе, который не работает? Много вопросов про это под уроком. На большинство нет нормального ответа и образ после этого так и не менялся. Что за подход?

Добавил 2 файла:

`tox-requirements.txt`:
```yaml
selinux
lxml
molecule
molecule_podman
jmespath
```

`tox.ini`:
```yaml
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{310}-ansible{217}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible217: ansible<3.0
commands =
    {posargs:molecule test -s compatibility --destroy always}
```

Версии `python` и `ansible`:

![image](https://github.com/user-attachments/assets/242a3955-7f3f-4f06-82a9-78e2ceb30d27)

Когда запускаю `tox` все просто зависает и при прерывании выдает ошибку:

![image](https://github.com/user-attachments/assets/29c50dc3-2ac2-4e04-baa1-4221ea160452)
![image](https://github.com/user-attachments/assets/ea5e1468-60fc-4104-9d89-2324c4d3e008)

Если смотреть с ключем `-vvv`, то вроде идет что-то, но просто нереально долго и по итогу машина теряет ssh соединение.

![image](https://github.com/user-attachments/assets/8dd40b61-3974-48b5-8d4d-eb992d2a8000)

> [!TIP]
> [Ссылка на релиз с заданием tox](https://github.com/NikitaLGit/vector-role/releases/tag/v1.0.2)
