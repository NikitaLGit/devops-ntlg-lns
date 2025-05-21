variable "cloud_id" {
  type = string
  sensitive = true
}
variable "folder_id" {
  type = string
  sensitive = true
}
variable "zone" {
  type = string
}

variable "network_id" {
  type = string
  sensitive = true
}
variable "security_group_ids" {
  type = list(string)
  sensitive = true
}
variable "subnet_id" {
  type = string
  sensitive = true
}


variable "mysql_clstr_conf" {
    type = map(any)
    default = {
        name                = "mysql-clstr-lns"
        environment         = "PRESTABLE"
        version             = "8.0"
        deletion_protection = false

        resource_preset_id = "b1.medium"
        disk_type_id       = "network-hdd"
        disk_size          = 10

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
    sensitive = true
}