variable "vpc_name" {
  type        = string
  default     = "def_production"
}

variable "subnets" {
  type = map
  default = {
    zone = "def_ru-central1-a"
    cidr = "10.0.100.0/24"
  }
}