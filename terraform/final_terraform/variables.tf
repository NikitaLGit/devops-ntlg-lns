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

variable "vpc_name" {
  type        = string
  default     = "finalter"
  description = "VPC network & subnet name"
}

variable "source_file" {
  type = string
  default = "terraform.tfstate"
}

variable "vms_resources" {
  type = map
  default = {
      instance_name  = "web"
      instance_count = 1
      image_family   = "ubuntu-2004-lts"
      public_ip      = true
    }
  }

variable "metadata_base" {
  type = object({
    ssh_name = string
    serial-port-enable = number
    ssh_public_key = string
  })
  default = {
    ssh_name = "default"
    serial-port-enable = 1
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKo1PzFWONiyzmkyJFXWIDYAy3zQuyCimmPFTF99eLfY lns@lnsnetol2"
  }
}

variable "mysql_user_conf" {
    type = object({
        name       = string
        password   = string
    })
    sensitive = true
}
