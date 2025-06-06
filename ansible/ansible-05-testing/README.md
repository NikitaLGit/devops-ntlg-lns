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
  vars:
    vector_config_path: /etc/vector/vector.yaml
  tasks:
    - name: Get Vector version
      ansible.builtin.command: "vector --version"
      changed_when: false
      register: vector_version
    - name: Assert Vector instalation
      assert:
        that: "'{{ vector_version.rc }}' == '0'"

    - name: Validation Vector configuration
      ansible.builtin.command: "vector validate --no-environment --config-yaml /etc/vector/vector.yaml"
      changed_when: false
      register: vector_validate
    - name: Assert Vector validate config
      assert:
        that: "'{{ vector_validate.rc }}' == '0'"
```

