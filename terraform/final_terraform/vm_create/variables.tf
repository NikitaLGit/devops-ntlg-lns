variable "env_name" {
  type    = string
  default = null
}

variable "network_id" {
  type = string
  sensitive = true
}

variable "subnet_zones" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
  sensitive = true
}

variable "instance_name" {
  type    = string
  default = "vm"
}

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

variable "platform" {
   type          = string
   default       = "standard-v1"
   description   = "Example to validate VM platform."
   validation {
     condition = contains(["standard-v1", "standard-v2", "standard-v3"], var.platform)
     error_message = "Invalid platform provided."
   }
}

variable "service_account_id" {
  type    = string
  default = null
  sensitive = true
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_cores" {
  type    = number
  default = 2
}

variable "instance_memory" {
  type    = number
  default = 1
}

variable "instance_core_fraction" {
  type    = number
  default = 5
}

variable "boot_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "boot_disk_size" {
  type    = number
  default = 10
}

variable "public_ip" {
  type    = bool
  default = false
  sensitive = true
}

variable "known_internal_ip" {
  default = ""
}

variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "preemptible" {
  type = bool
  default = true
}

variable "ssh_public_key" {
  type = string
}

variable "metadata" {
  description = "for dynamic block 'metadata' "
  type        = map(string)
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "labels" {
  description = "for dynamic block 'labels' "
  type        = map(string)
  default = {}
}

variable "description" {
  type = string
  default = "TODO: description;"
}

variable "yandex_vpc_network_finalter_id" {
  type = string
  sensitive = true
}

## переменные для правил доступа
variable "security_group_ingress" {
  description = "secrules ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий ssh"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий  http"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
  ]
}

variable "security_group_egress" {
  description = "secrules egress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    { 
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}
