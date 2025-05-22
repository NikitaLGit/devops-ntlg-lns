output "dynamodb_endpoint" {
  value = yandex_ydb_database_serverless.lns_ydb.ydb_api_endpoint
}

output "dynamodb_table" {
  value = var.table
}