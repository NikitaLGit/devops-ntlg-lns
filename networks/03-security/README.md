## Задание 1

Создаем роль для службы KMS, которая даст возможность зашифровывать и расшифровывать данные:

```bash
resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.service.id}"
}
```

Создаем симметричный ключ шифрования с алгоритмом шифрования AES_128 и временем жизни 24 часа:

```bash
resource "yandex_kms_symmetric_key" "secret-key" {
  name              = "key-1"
  description       = "ключ для шифрования бакета"
  default_algorithm = "AES_128"
  rotation_period   = "24h"
}
```

Применяем ключ шифрования к созданному ранее бакету:

```bash
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.secret-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
```

После применения кода:

<img width="1203" height="492" alt="image" src="https://github.com/user-attachments/assets/dd1e6065-80a7-48ab-9156-1203cb731301" />

Ключ шифрования создан!

Откроем зашифрованный файл в браузере:

<img width="800" height="243" alt="image" src="https://github.com/user-attachments/assets/d8e75951-d70c-47cd-8653-852c0fb02214" />

Т.к. он зашифрован, то доступа к файлу в бакете нет
