variable "env_name" {
  type        = string
  default     = "def_develop"
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