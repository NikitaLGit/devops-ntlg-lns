variable "env_name" {
  type        = string
  default     = "ans_net"
  description = "env_name"
}
variable "folder_id" {
  type = string
  sensitive = true
}
variable "cloud_id" {
  type = string
  sensitive = true
}
variable "zone" {
  type = string
  sensitive = true
}

variable "subnets" {
  type = list(object({
    zone=string,
    cidr=string
    }))
  default = [{
    zone = "ru-central1-a",
    cidr = "10.0.100.0/24"
  }]
}