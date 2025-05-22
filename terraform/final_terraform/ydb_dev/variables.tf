variable "cloud_id" {
  type = string
  sensitive = true
}
variable "folder_id" {
  type = string
  sensitive = true
}
variable "zone" {
  type = string
}

variable "table" {
    type = string
    default = "tfstate-lock"
}

variable "file" {
  type = string
}