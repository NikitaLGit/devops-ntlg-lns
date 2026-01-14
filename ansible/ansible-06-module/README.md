Настроим окружение
<img width="1353" height="874" alt="image" src="https://github.com/user-attachments/assets/7aec9e2b-494d-40df-88a8-88f0959d7447" />

в `library/my_own_module.py` вставим

```bash
#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule
import os

def main():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True),
    )

    result = dict(
        changed=False,
        message=''
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    path = module.params['path']
    content = module.params['content']

    # Проверяем: существует ли файл
    if os.path.exists(path):
        with open(path, 'r') as f:
            existing_content = f.read()

        if existing_content == content:
            result['changed'] = False
            result['message'] = 'File already exists with correct content'
            module.exit_json(**result)

    # Если check_mode — просто говорим, что были бы изменения
    if module.check_mode:
        result['changed'] = True
        module.exit_json(**result)

    # Создаём или перезаписываем файл
    with open(path, 'w') as f:
        f.write(content)

    result['changed'] = True
    result['message'] = 'File created or updated'
    module.exit_json(**result)


if __name__ == '__main__':
    main()
```

Код тестового модуля

```yaml
- name: Test custom module
  hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Create file using my own module
      my_own_module:
        path: ./my_own_file.txt
        content: "Hello from my own module"

```

Отрабатывает. Модуль идемпотентен
<img width="1376" height="443" alt="image" src="https://github.com/user-attachments/assets/8f343bee-6740-4ab2-825e-49697c17da8b" />

выйдем из окружения = `deactivate`

Инициализируем коллекцию
<img width="1275" height="54" alt="image" src="https://github.com/user-attachments/assets/4eaa3a47-9d0a-4a33-8fe8-57148813fdb8" />

Сделаем базовый плейбук для проверки

`playbook_role.yml`
```yaml
- name: Test role from collection
  hosts: localhost
  connection: local
  gather_facts: false

  roles:
    - simple_file
```

`tasks/main.yml`
```yaml
- name: Create file via custom module
  my_own_namespace.yandex_cloud_elk.my_own_module:
    path: "{{ file_path }}"
    content: "{{ file_content }}"
```

`defaults/main.yml`
```yaml
file_path: /tmp/role_file.txt
file_content: "Hello from role"
```

запушим измененения и документацию с тегом релиза

```bash
git add .
git commit -m "Initial release"
git tag 1.0.0
git push --tags
```

теперь соберем tar.gz
<img width="1541" height="66" alt="image" src="https://github.com/user-attachments/assets/e29a7968-0ad8-42e3-b3a9-bea440f5bc9f" />

поставим роль из локального архива
<img width="1235" height="100" alt="image" src="https://github.com/user-attachments/assets/f773f25b-a3ef-446d-a678-ed1b7f203937" />

запустим playbook и убедимся что он работает

```bash
 lns@lnsnetol2  ~/git_devops/virtd-homeworks/ansible/ansible-06-module/my_own_namespace/studyrole   main ±  ansible-galaxy collection build                                           

Created collection for my_own_namespace.studyrole at /home/lns/git_devops/virtd-homeworks/ansible/ansible-06-module/my_own_namespace/studyrole/my_own_namespace-studyrole-1.0.0.tar.gz
 lns@lnsnetol2  ~/git_devops/virtd-homeworks/ansible/ansible-06-module/my_own_namespace/studyrole   main ±  cp my_own_namespace-studyrole-1.0.0.tar.gz ~/test_install 
 lns@lnsnetol2  ~/git_devops/virtd-homeworks/ansible/ansible-06-module/my_own_namespace/studyrole   main ±  cd -
~/test_install
 lns@lnsnetol2  ~/test_install  ansible-galaxy collection install my_own_namespace-studyrole-1.0.0.tar.gz --force        
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.studyrole:1.0.0' to '/home/lns/.ansible/collections/ansible_collections/my_own_namespace/studyrole'
my_own_namespace.studyrole:1.0.0 was installed successfully
 lns@lnsnetol2  ~/test_install  ansible-playbook ./playbook_role.yml -vvv                                                                          

ansible-playbook [core 2.17.12]
  config file = None
  configured module search path = ['/home/lns/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/lns/.local/lib/python3.10/site-packages/ansible
  ansible collection location = /home/lns/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible-playbook
  python version = 3.10.12 (main, Jan  8 2026, 06:52:19) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
No config file found; using defaults
host_list declined parsing /etc/ansible/hosts as it did not pass its verify_file() method
script declined parsing /etc/ansible/hosts as it did not pass its verify_file() method
auto declined parsing /etc/ansible/hosts as it did not pass its verify_file() method
Parsed /etc/ansible/hosts inventory source with ini plugin
Skipping callback 'default', as we already have a stdout callback.
Skipping callback 'minimal', as we already have a stdout callback.
Skipping callback 'oneline', as we already have a stdout callback.

PLAYBOOK: playbook_role.yml ******************************************************************************************************************************************************************
1 plays in ./playbook_role.yml

PLAY [Test role from collection] *************************************************************************************************************************************************************

TASK [my_own_namespace.studyrole.simple_file : Create file via custom module] ****************************************************************************************************************
task path: /home/lns/.ansible/collections/ansible_collections/my_own_namespace/studyrole/roles/simple_file/tasks/main.yml:1
<localhost> ESTABLISH LOCAL CONNECTION FOR USER: lns
<localhost> EXEC /bin/sh -c 'echo ~lns && sleep 0'
<localhost> EXEC /bin/sh -c '( umask 77 && mkdir -p "` echo /home/lns/.ansible/tmp `"&& mkdir "` echo /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064 `" && echo ansible-tmp-1768388224.6239169-92197-87162459589064="` echo /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064 `" ) && sleep 0'
<localhost> Attempting python interpreter discovery
<localhost> EXEC /bin/sh -c 'echo PLATFORM; uname; echo FOUND; command -v '"'"'python3.12'"'"'; command -v '"'"'python3.11'"'"'; command -v '"'"'python3.10'"'"'; command -v '"'"'python3.9'"'"'; command -v '"'"'python3.8'"'"'; command -v '"'"'python3.7'"'"'; command -v '"'"'/usr/bin/python3'"'"'; command -v '"'"'python3'"'"'; echo ENDFOUND && sleep 0'
<localhost> EXEC /bin/sh -c '/usr/bin/python3.10 && sleep 0'
<localhost> Python interpreter discovery fallback (unsupported Linux distribution: ubuntu)
Using module file /home/lns/.ansible/collections/ansible_collections/my_own_namespace/studyrole/plugins/modules/my_own_module.py
<localhost> PUT /home/lns/.ansible/tmp/ansible-local-921740tzonq57/tmpo6768owa TO /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064/AnsiballZ_my_own_module.py
<localhost> EXEC /bin/sh -c 'chmod u+rwx /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064/ /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064/AnsiballZ_my_own_module.py && sleep 0'
<localhost> EXEC /bin/sh -c '/usr/bin/python3.10 /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064/AnsiballZ_my_own_module.py && sleep 0'
<localhost> EXEC /bin/sh -c 'rm -f -r /home/lns/.ansible/tmp/ansible-tmp-1768388224.6239169-92197-87162459589064/ > /dev/null 2>&1 && sleep 0'
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning
of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
changed: [localhost] => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": true,
    "invocation": {
        "module_args": {
            "content": "Hello from role",
            "path": "/tmp/role_file.txt"
        }
    },
    "message": "File created or updated"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

 lns@lnsnetol2  ~/test_install  ansible-playbook ./playbook_role.yml     


PLAY [Test role from collection] *************************************************************************************************************************************************************

TASK [my_own_namespace.studyrole.simple_file : Create file via custom module] ****************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning
of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
