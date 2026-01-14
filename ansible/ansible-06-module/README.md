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

