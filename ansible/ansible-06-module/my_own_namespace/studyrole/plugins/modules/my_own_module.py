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
