resource "yandex_mdb_mysql_cluster" "lns-mysql-final" {
  name                = var.mysql_clstr_conf.name
  environment         = var.mysql_clstr_conf.environment
  network_id          = var.mysql_clstr_conf.network_id
  version             = var.mysql_clstr_conf.version
  security_group_ids  = [var.mysql_clstr_conf.security_group_ids]
  deletion_protection = var.mysql_clstr_conf.deletion_protection

  resources {
    resource_preset_id = var.mysql_clstr_conf.resource_preset_id
    disk_type_id       = var.mysql_clstr_conf.disk_type_id
    disk_size          = var.mysql_clstr_conf.disk_size
  }

  host {
    zone             = var.subnets.zone
    subnet_id        = yandex_vpc_subnet.sub_finalter.id
    assign_public_ip = var.mysql_clstr_conf.assign_public_ip
    priority         = var.mysql_clstr_conf.priority
    backup_priority  = var.mysql_clstr_conf.backup_priority
  }
}

resource "yandex_mdb_mysql_database" "<имя_БД>" {
  cluster_id = yandex_mdb_mysql_cluster.lns-mysql-final.id
  name       = var.mysql_db_conf.name
}

resource "yandex_mdb_mysql_user" "<имя_пользователя>" {
  cluster_id = yandex_mdb_mysql_cluster.lns-mysql-final.id
  name       = var.mysql_user_conf.name
  password   = var.mysql_user_conf.password
  permission {
    database_name = var.mysql_db_conf.name
    roles         = ["ALL"]
  }
}