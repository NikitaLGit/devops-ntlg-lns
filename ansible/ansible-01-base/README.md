## Задание 1

```yaml
ok: [localhost]

TASK [Print OS] ********
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Задание 2

`./group_vars/all/examp.yml`

## Задание 4
```yaml
TASK [Print OS] *********
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```

## Задание 6

```yaml
TASK [Print OS] *********
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```

## Задание 8
```bash
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
```

все ок

## Задание 9

