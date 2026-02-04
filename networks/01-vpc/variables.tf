variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "vpc_name" {
  type        = string
  default     = "vpchome1"
  description = "env_name_parameter"
}

variable "default_public" {
  type = map
  default = {
    name = "public-ru-central1-b"
    zone = "ru-central1-b"
    cidr = "192.168.10.0/24"
  }
}

variable "default_private" {
  type = map
  default = {
    name = "private-ru-central1-b"
    zone = "ru-central1-b"
    cidr = "192.168.20.0/24"
  }
}