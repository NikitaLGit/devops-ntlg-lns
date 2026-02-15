## cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}


variable "default_zone" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  description = "Zone for subnets"
}

variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network name"
}  

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24", "192.168.11.0/24", "192.168.12.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24", "192.168.21.0/24", "192.168.22.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}


variable "vpc_subnet_name_public" {
  type        = string
  default     = "public"
  description = "VPC subnet name"
}

variable "vpc_subnet_name_private" {
  type        = string
  default     = "private"
  description = "VPC subnet name"
}

variable "bucket_name" {
  type        = string
  default     = "vladmgb-bucket-27102025"
  description = "Name of the Object Storage bucket"
}


variable "image_file_path" {
  type        = string
  default     = "./image.jpg"
  description = "Path to the image file"
}

variable "image_url" {
  description = "Public URL of the image in Object Storage"
  type        = string
  default     = "https://storage.yandexcloud.net/leonov-bucket-15022026/york.jpg"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/ubuntu.pub"
}

variable "vm_user" {
  description = "Username for VM access"
  type        = string
  default     = "ubuntu"
}

variable "web_page_title" {
  description = "Title for the web page"
  type        = string
  default     = "Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»"
}


variable "instance_count" {
  description = "Number of instances in the group"
  type        = number
  default     = 3
}

variable "vm_resources" {
  description = "VM resources configuration"
  type = object({
    memory = number
    cores  = number
    core_fraction = number
  })
  default = {
    memory = 2
    cores  = 2
    core_fraction = 5
  }
}

variable "region" {
  description = "Yandex.Cloud region"
  type        = string
  default     = "ru-central1"
}


variable "kms_default_algorithm" {
  description = "Default encryption algorithm for KMS key"
  type        = string
  default     = "AES_128"
}

variable "kms_rotation_period" {
  description = "Key rotation period in hours"
  type        = string
  default     = "8760h" # 1 год
}

variable "mysql_version" {
  type        = string
  default     = "8.0"
  description = "MySQL version"
}

variable "mysql_user" {
  type        = string
  default     = "netology_user"
  description = "MySQL user name"
}

variable "mysql_password" {
  type        = string
  sensitive   = true
  description = "MySQL user password"
}

variable "mysql_database" {
  type        = string
  default     = "netology_db"
  description = "MySQL database name"
}

variable "mysql_backup_start" {
  type        = string
  default     = "23:59"
  description = "MySQL backup start time"
}


variable "k8s_cluster_name" {
  type        = string
  default     = "netology-k8s-cluster"
  description = "Kubernetes cluster name"
}

variable "k8s_cluster_version" {
  type        = string
  default     = "1.32"
  description = "Kubernetes version"
}

variable "k8s_node_group_name" {
  type        = string
  default     = "netology-node-group"
  description = "Kubernetes node group name"
}

variable "k8s_service_account_name" {
  type        = string
  default     = "k8s-service-account"
  description = "Kubernetes service account name"
}
