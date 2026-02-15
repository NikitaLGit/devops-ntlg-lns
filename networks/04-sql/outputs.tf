output "mysql_connection_string" {
  description = "MySQL connection string example"
  value       = "mysql -h ${yandex_mdb_mysql_cluster.netology_mysql.host.0.fqdn} -u ${var.mysql_user} -p ${var.mysql_database}"
  sensitive   = true
}