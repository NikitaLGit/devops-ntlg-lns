resource "yandex_mdb_mysql_cluster" "lns-mysql-clstr" {
  name                = var.mysql_clstr_conf.name
  environment         = var.mysql_clstr_conf.environment
  network_id          = var.network_id
  version             = var.mysql_clstr_conf.version
  security_group_ids  = var.security_group_ids
  deletion_protection = var.mysql_clstr_conf.deletion_protection
  folder_id           = var.folder_id

  resources {
    resource_preset_id = var.mysql_clstr_conf.resource_preset_id
    disk_type_id       = var.mysql_clstr_conf.disk_type_id
    disk_size          = var.mysql_clstr_conf.disk_size
  }

  access {
    data_lens = true
    web_sql   = true
  }

  host {
    zone             = var.zone
    subnet_id        = var.subnet_id
    assign_public_ip = var.mysql_clstr_conf.assign_public_ip
    priority         = var.mysql_clstr_conf.priority
    backup_priority  = var.mysql_clstr_conf.backup_priority
  }
}

resource "yandex_mdb_mysql_database" "lns-mysql-db" {
  cluster_id = yandex_mdb_mysql_cluster.lns-mysql-clstr.id
  name       = var.mysql_db_conf.name
}

resource "yandex_mdb_mysql_user" "lns-mysql-user" {
  cluster_id = yandex_mdb_mysql_cluster.lns-mysql-clstr.id
  name       = var.mysql_user_conf.name
  password   = var.mysql_user_conf.password
  permission {
    database_name = var.mysql_db_conf.name
    roles         = ["ALL"]
  }
  depends_on = [ yandex_mdb_mysql_database.lns-mysql-db ]
}