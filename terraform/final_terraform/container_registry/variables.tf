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

variable "cr_user_conf" {
  type = map(any)
  default = {
    name = "cr-editor-lns"
    role = "editor"
  }
}

variable "cr_conf" {
  type = map(any)
  default = {
    registry_name = "cr-lns-main"
    role = "container-registry.editor"
  }
}