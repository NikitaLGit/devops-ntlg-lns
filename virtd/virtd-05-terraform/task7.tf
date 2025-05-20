# Создание сервисного аккаунта
resource "yandex_iam_service_account" "sa" {
  name = var.s3_conf.service_name
  description = "test account for task 7"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = var.folder_id
  role      = var.s3_conf.sa_role
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Создание бакета с использованием статического ключа
resource "yandex_storage_bucket" "netology-s3-1g-bucket" {
  access_key            = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket                = var.s3_conf.name
  max_size              = var.s3_conf.size
  default_storage_class = var.s3_conf.storage_class
  grant {
    id          = yandex_iam_service_account.sa.id
    type        = var.s3_conf.type
    permissions = [var.s3_conf.permissions]
  }
  anonymous_access_flags {
    read        = var.s3_conf.flags_read
    list        = var.s3_conf.flags_list
    config_read = var.s3_conf.flags_config_read
  }
  tags = {
    test7key = "test7value"
  }

  force_destroy = var.s3_conf.force_destroy
}

#создание базы данных
resource "yandex_ydb_database_serverless" "database1" {
  name                = var.ydb_conf.name
  folder_id = var.folder_id
  deletion_protection = var.ydb_conf.deletion_protection
  location_id = var.ydb_conf.location_id

  serverless_database {
    enable_throttling_rcu_limit = var.ydb_conf.enable_throttling_rcu_limit
    provisioned_rcu_limit       = var.ydb_conf.provisioned_rcu_limit
    storage_size_limit          = var.ydb_conf.storage_size_limit
    throttling_rcu_limit        = var.ydb_conf.throttling_rcu_limit
  }
  labels = {
    test7 = "test7"
  }
}