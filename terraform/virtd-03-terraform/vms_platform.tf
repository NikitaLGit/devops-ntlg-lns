variable "platform" {
  type = map
  default = {
    family                    = "ubuntu-2004-lts"
    platform_id               = "standard-v3"
    allow_stopping_for_update = true
    size                      = 10
    type                      = "network-hdd"    
    }
}

variable "vms_resources" {
  type = map
  default = {
    low = {
      cores         =2
      memory        =1
      core_fraction =5
    },
    mid ={
      cores         =4
      memory        =2
      core_fraction =20
    }
  }
}