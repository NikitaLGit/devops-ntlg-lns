locals {
  labels = length(keys(var.labels)) >0 ? var.labels: {
    "env"=var.env_name
    "project"="undefined"
  }
}
