# Создание сервисного аккаунта
resource "yandex_iam_service_account" "s3-sa" {
  name = var.s3_conf.service_name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "s3-admin" {
  folder_id = var.folder_id
  role      = var.s3_conf.sa_role
  member    = "serviceAccount:${yandex_iam_service_account.s3-sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "s3-static-key" {
  service_account_id = yandex_iam_service_account.s3-sa.id
  description        = "static access key for object storage"
}

# Создание бакета с использованием статического ключа
resource "yandex_storage_bucket" "s3-bucket-lns" {
  access_key            = yandex_iam_service_account_static_access_key.s3-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.s3-static-key.secret_key
  bucket                = var.s3_conf.name
  max_size              = var.s3_conf.size
  default_storage_class = var.s3_conf.storage_class

  anonymous_access_flags {
    read        = var.s3_conf.flags_read
    list        = var.s3_conf.flags_list
    config_read = var.s3_conf.flags_config_read
  }

  versioning {
    enabled = true
  }

  tags = {
    author = "nleonov"
  }

  force_destroy = var.s3_conf.force_destroy
}

resource "yandex_storage_object" "s3-object-lns" {
  bucket = var.s3_conf.name
  key    = var.source_file
  source = "./${var.source_file}"
}
