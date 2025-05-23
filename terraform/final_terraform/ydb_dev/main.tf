resource "yandex_ydb_database_serverless" "lns_ydb" {
  name      = "tfstate-lock-lns"
  folder_id = var.folder_id
  location_id = "ru-central1"

  deletion_protection = false
}

resource "yandex_ydb_database_iam_binding" "editor" {
  database_id = yandex_ydb_database_serverless.lns_ydb.id
  role        = "ydb.editor"

  members = [
    "serviceAccount:ajed6hclf66f9k40qmij",
  ]
}

resource "yandex_ydb_table" "lns_table" {
  path              = "tfstate-lock"
  connection_string = yandex_ydb_database_serverless.lns_ydb.ydb_full_endpoint

  column {
    name     = "LockID"
    type     = "Utf8"
    not_null = true
  }

  primary_key = ["LockID"]
}