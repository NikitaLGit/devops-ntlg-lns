###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
  sensitive = true
  validation {
    condition = length(var.token) >= 32
    error_message = "Must be at least 32 character long API token."
  }
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive = true
  validation {
    condition = length(var.cloud_id) == 20
    error_message = "cloud_id var must be 20 character long"
  }
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  sensitive = true
  validation {
    condition = length(var.folder_id) == 20
    error_message = "folder_id var must be 20 character long"
  }
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
  validation {
    condition = contains(["ru-central1-a", "ru-central1-b", "ru-central1-d"], var.default_zone)
    error_message = "Wrong type of zone. Must be 'ru-central1-{a/b/c}'"
  }
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  validation {
    condition = alltrue([
      for a in var.default_cidr : can(cidrnetmask(a))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
  validation {
    condition = length(var.vpc_name) >= 3
    error_message = "vpc_name var must be 3 or more character long"
  }
}

#variables for task 7

variable "s3_conf" {
  type = map(any)
  default = {
    service_name = "s3task7"
    sa_role      = "storage.admin"
    name         = "netology-lns-s3-task7"
    size         = 1073741824
    storage_class = "standard"
    flags_read        = false
    flags_list        = false
    flags_config_read = false
    force_destroy    = false
    type        = "CanonicalUser"
    permissions = "FULL_CONTROL"
  }
}

variable "ydb_conf" {
  type = map(any)
  default = {
    name                = "test-sl-task7"
    deletion_protection = false
    location_id = "ru-central1"
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 1
    throttling_rcu_limit        = 0
  }
}