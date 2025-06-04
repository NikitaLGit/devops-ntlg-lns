В папке `create_vms/` образы для 3х хостов. НА них ставится `clickhouse`/ `vector`/ `lighthouse` + `nginx`

Clickhouse просто устанавливается. в нем создается база `logs` и таблица `logs_table` (из переменных в `group_vars/all/all_vars.yml`).
Таблица на основе файла в `templates/vector/nginx_logs_tables.sql.j2`

В `vector` загружается конфиг из файла `templates/vector/vector.yaml.j2`

В хост для `lighthouse` ставим `lighthouse` + `nginx`. `Nginx` на `80` порту, а `lighthouse` на `8080`.
Конфиг для `lighthouse` из файла `templates/nginx/lighthouse.conf.j2` 
