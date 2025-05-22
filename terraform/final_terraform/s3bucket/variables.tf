variable "s3_conf" {
  type = object({
    service_name = string
    sa_role      = string
    name      = string
    key          = string
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
    name         = "lns-bucket-final"
    key = ""
    size         = 1073741824
    storage_class = "standard"
    flags_read        = false
    flags_list        = false
    flags_config_read = false
    force_destroy    = false
  }
}

variable "cloud_id" {
  type        = string
  sensitive = true
}

variable "folder_id" {
  type        = string
  sensitive = true
}

variable "zone" {
  type = string
  default = "ru-central1-b"
}

variable "source_file" {
  type = string
}