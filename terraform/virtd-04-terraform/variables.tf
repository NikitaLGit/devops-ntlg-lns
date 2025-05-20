###cloud vars

variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

# variable "subnet" {
#   type        = string
# }

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "default_sub_b" {
  type = map
  default = {
    name = "develop-ru-central1-b"
    zone = "ru-central1-b"
    cidr = "10.0.2.0/24"
  }
}

variable "task_naming_a" {
  type        = string
  default     = "develop"
}
variable "task_naming_b" {
  type        = string
  default     = "analytics"
}

variable "vms_resources" {
  type = map
  default = {
    test = {
      instance_name  = "web"
      instance_count = 2
      image_family   = "ubuntu-2004-lts"
      public_ip      = true
      },
    example = {
      instance_name  = "web-stage"
      instance_count = 1
      image_family   = "ubuntu-2004-lts"
      public_ip      = true
      },
    }
  }

variable "vault" {
   type = object({
    ip              = string
    port            = string
    skip_tls_verify = bool
    token_vault     = string
    base_path       = string
  })
}

variable "metadata_base" {
  type = map
  default = {
    serial-port-enable = 1
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
  }
}
