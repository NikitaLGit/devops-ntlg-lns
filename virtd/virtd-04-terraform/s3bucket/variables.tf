variable "s3_conf" {
  type = object({
    service_name = string
    sa_role      = string
    name         = string
    size         = number
    storage_class = string
    flags_read        = bool
    flags_list        = bool
    flags_config_read = bool
    force_destroy    = bool
  })
  default = {
    service_name = "s3admin"
    sa_role      = "storage.admin"
    name         = "netology-s3-1g-bucket"
    size         = 1073741824
    storage_class = "standard"
    flags_read        = true
    flags_list        = true
    flags_config_read = false
    force_destroy    = false
  }
}

variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "zone" {
  type = string
  default = "default-ru-central1-b"
}