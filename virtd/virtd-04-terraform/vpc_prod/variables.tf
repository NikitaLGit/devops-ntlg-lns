variable "env_name" {
  type        = string
  default     = "def_production"
}

variable "subnets" {
  type = list(object({
    zone=string,
    cidr=string
    }))
  default = [{
    zone = "def_ru-central1-a",
    cidr = "10.0.200.0/24"
  },
  {
    zone = "def_ru-central1-b",
    cidr = "10.0.201.0/24"
  },
  {
    zone = "def_ru-central1-c",
    cidr = "10.0.202.0/24"
  }
  ]
}