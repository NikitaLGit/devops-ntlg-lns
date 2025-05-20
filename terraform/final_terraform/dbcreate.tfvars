variable "mysql_clstr_conf" {
    type = map(any)
    default = {
        name                = "mysql-clstr-lns"
        environment         = "PRESTABLE"
        network_id          = module.vpc_dev.net_id
        version             = "8.0"
        security_group_ids  = [module.vm_create.security_group_id]
        deletion_protection = true

        resource_preset_id = "s2.micro"
        disk_type_id       = "network-hdd"
        disk_size          = 10

        subnet_id        = "<идентификатор_подсети>"
        assign_public_ip = true
        priority         = 100
        backup_priority  = 100
    }
}

variable "mysql_db_conf" {
    type = map(any)
    default = {
        name       = "mysql-db-lns"
    }
}

variable "mysql_user_conf" {
    type = object({
        name       = string
        password   = string
    })
}