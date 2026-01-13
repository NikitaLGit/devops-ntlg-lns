## Задание 1

После запуска видим что получаем ответ от nginx c верным наполнением

<img width="1285" height="277" alt="image" src="https://github.com/user-attachments/assets/bfb2f9bf-0a17-42ee-8543-967f309e5c13" />

## Задание 2

Создали ключ tls, преобразовали его в base64 и закинули в secret-tls.yaml

Применим все yaml
<img width="973" height="200" alt="image" src="https://github.com/user-attachments/assets/32ff6eec-48f3-4905-b8af-eca4c57a5690" />

Все работает
<img width="994" height="167" alt="image" src="https://github.com/user-attachments/assets/1093b739-2151-4deb-babd-7391eb5610d9" />

## Задание 3

Включим RBAC
<img width="933" height="148" alt="image" src="https://github.com/user-attachments/assets/7d439c1d-69b0-4f91-a0c1-d0cebbcbe37d" />

Создадим SSL-сертификат для пользователя
<img width="1345" height="213" alt="image" src="https://github.com/user-attachments/assets/aff28d12-bb97-4750-9a4e-458e66ceb8d0" />

Применим yaml файлы 
<img width="1347" height="362" alt="image" src="https://github.com/user-attachments/assets/fec91c04-0c53-4b4c-be38-c854a705ae6b" />

Доступ к инфе о подах только под нужным юзером
<img width="1125" height="83" alt="image" src="https://github.com/user-attachments/assets/5099e204-fcf7-4f3e-9b97-a24f8b8dca14" />
