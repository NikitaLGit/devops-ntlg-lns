variable "vm_web" {
  type = map
  default = {
    family                    = "ubuntu-2004-lts"
    platform_id               = "standard-v1"
    allow_stopping_for_update = true
    }
}

variable "vm_db" {
  type = map
  default = {
    family                    = "ubuntu-2004-lts"
    platform_id               = "standard-v3"
    allow_stopping_for_update = true
    }
}

variable "vms_resources" {
  type = map
  default = {
    low = {
      cores=2
      memory=1
      core_fraction=5
    },
    mid ={
      cores=4
      memory=2
      core_fraction=20
    }
  }
}

variable "naming" {
  type = map
  default = {
    web = {
      who   = "netology-develop-platform"
      name  = "web"
    },
    db = {
      who   = "netology-develop-platform"
      name  = "db"
    }
  }
}