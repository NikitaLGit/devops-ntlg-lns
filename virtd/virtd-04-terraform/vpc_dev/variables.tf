variable "env_name" {
  type        = string
  default     = "def_develop"
  description = "env_name_parametr"
}

variable "subnets" {
  type = list(object({
    zone=string,
    cidr=string
    }))
  default = [{
    zone = "def_ru-central1-a",
    cidr = "10.0.100.0/24"
  }]
}