## Подготовка

Cоздадим 2 машины для сервера `Teamcity` и для агента

![image](https://github.com/user-attachments/assets/e413f134-544e-4228-812b-d711674f4a9e)

Для сервера сделаем статический адрес.
Зайдем на сервер и произведем первоначальную настройку

![image](https://github.com/user-attachments/assets/288a7558-f552-4b5c-9403-434b43bcd3ed)

Подключим агента к серверу

> [!WARNING]
> НЕ ПРОСТО ПРОПИСАВ ПАРАМЕТР, А ЦЕЛЫЙ КВЕСТ ОПЯТЬ

На агент поставим требуемые программы и версию `jdk` >= `21`

![image](https://github.com/user-attachments/assets/d60e9ae8-066c-4ced-9094-abd8b4026736)

на сервере укажем куда установить агент

![image](https://github.com/user-attachments/assets/9b2268bb-f1b4-426f-9653-df026749fcc9)

И после верной установки получим агента в списке агентов

![image](https://github.com/user-attachments/assets/8a55484d-1924-4de1-87a0-3b02e1b5f3c5)

Запустим `nexus` создадим сервер на `Fedora` (спасибо вопросам под ДЗ)

![image](https://github.com/user-attachments/assets/817eaaca-dad8-412d-8723-e74225d2e452)

С локального сервера запустим `playbook`. С боем и спустя часа 2 получилось, но все равно пишет что не запускается сервис. Права есть на папку полные (после запускаем вручную)

![image](https://github.com/user-attachments/assets/76e6b6a5-d1de-4702-9246-7765a29167c8)

На сервере `nexus`

![image](https://github.com/user-attachments/assets/2c71c71f-720b-4a40-b771-d73155043358)

## Задание

> 1-7.

Cоздадим `fork`

![image](https://github.com/user-attachments/assets/181782dd-48e6-4b9f-a53a-166b0275dbe1)

Создадим проект на основе репозитория и оставим название `Build`

![image](https://github.com/user-attachments/assets/6076a306-aea7-483e-b1c2-7854e6c99a98)

Автоопределение сработало

Загрузим файл настроек

![image](https://github.com/user-attachments/assets/a21d43f7-7293-4117-b1a4-1194c9efc322)

![image](https://github.com/user-attachments/assets/23308387-8b5b-40de-af48-9fad54cdffa3)

В `nexus` все появилось

![image](https://github.com/user-attachments/assets/b51f41ca-9883-4d6d-ad94-49ca513c3f95)

> 8. 

> [!WARNING]
> как обычно показано одно, а оно уже устарело и приходится переделывать. Это ужас.
>
> Пересоздал проект и подключил его через `ssh`

Все заработало

![image](https://github.com/user-attachments/assets/80a9a78d-3ed1-41e4-a4b4-1cdef6f46a7c)

![image](https://github.com/user-attachments/assets/2794ff27-f458-44ac-a04b-072b5d2871ec)

> 9-14.

Создадим новую `ветку`

![image](https://github.com/user-attachments/assets/9d30c653-1a69-473f-9226-9588f6458ae8)

Внесем требуемый код

![image](https://github.com/user-attachments/assets/f33b7fa5-df6d-4827-a2be-c1ee51944108)

![image](https://github.com/user-attachments/assets/bd256fdb-7cc2-4f3d-beb9-c4edfe0b5be6)

Загрузили изменения в новую ветку. Все самостоятельно запустилось и прошло успешно

![image](https://github.com/user-attachments/assets/4e122d47-1e94-4b44-8025-6842b4b88345)

`Merge` ветку `feature` в ветку `master`

![image](https://github.com/user-attachments/assets/6836af6d-6ea2-45f2-822d-e10951215147)

> [!WARNING]
> Так как у меня 2 проекта на 1 репозиторий, то бывает первый проект выполняет что-то.
>
> `КАК ЕГО УДАЛИТЬ Я НЕ НАШЕЛ ВООБЩЕ!`

В `nexus` все прошло верно и загрузилась версия `0.0.3`

![image](https://github.com/user-attachments/assets/e376fc77-c55b-4d62-b0c4-3a164aa45510)

> 15.

Новый арфтекат не загружается показывая ошибку `400` - `версия артефакта уже присутствует в репозитории Maven`

> 16-19.

![image](https://github.com/user-attachments/assets/fac760ef-5862-47b5-b535-d71ef9220155)

![image](https://github.com/user-attachments/assets/54c946b9-581b-4d4b-a805-00d9c38719c8)

Последние настройки конфигурации

![image](https://github.com/user-attachments/assets/d449e8a9-7c31-44a6-a186-aff9b8cf1178)

[Ссылка на репозиторий](https://github.com/NikitaLGit/example-teamcity)
