# Создание сервисного аккаунта
resource "yandex_iam_service_account" "cr-user" {
  name = var.cr_user_conf.name
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "cr-role" {
  folder_id = var.folder_id
  role      = var.cr_user_conf.role
  member    = "serviceAccount:${yandex_iam_service_account.cr-user.id}"
}

# Создание статического ключа доступа
# resource "yandex_iam_service_account_static_access_key" "cr-static-key" {
#   service_account_id = yandex_iam_service_account.cr-user.id
#   description        = "static access key for object storage"
# }

resource "yandex_container_registry" "cr-registry" {
  folder_id = var.folder_id
  name      = var.cr_conf.registry_name
}

resource "yandex_container_registry_iam_binding" "editor" {
  registry_id = yandex_container_registry.cr-registry.id
  role        = var.cr_conf.role

  members = [
    "serviceAccount:${yandex_iam_service_account.cr-user.id}",
  ]
}