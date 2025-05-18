variable "vpc_name" {
  type        = string
  default     = "def_develop"
}

variable "subnets" {
  type = map
  default = {
    zone = "def_ru-central1-a"
    cidr = "10.0.200.0/24"
  }
}