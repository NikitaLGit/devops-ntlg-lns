###### Networks

resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "private" {
  count = length(var.default_zone)
  name           = "${var.vpc_subnet_name_private}-${var.default_zone[count.index]}"
  zone           = var.default_zone[count.index]
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = [var.private_cidr[count.index]]
}

resource "yandex_vpc_subnet" "public" {
  count = length(var.default_zone)
  name           = "${var.vpc_subnet_name_public}-${var.default_zone[count.index]}"
  zone           = var.default_zone[count.index]
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = [var.public_cidr[count.index]]
}

# Security Groups
resource "yandex_vpc_security_group" "k8s_master_sg" {
  name        = "k8s-master-security-group"
  description = "Security group for Kubernetes master"
  network_id  = yandex_vpc_network.netology.id

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API server"
    port           = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_node_sg" {
  name        = "k8s-node-security-group"
  description = "Security group for Kubernetes nodes"
  network_id  = yandex_vpc_network.netology.id

  ingress {
    protocol          = "TCP"
    description       = "NodePort services"
    from_port         = 30000
    to_port           = 32767
    v4_cidr_blocks    = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "ANY"
    description       = "Internal pod communication"
    v4_cidr_blocks    = ["10.1.0.0/16", "10.2.0.0/16"]
    from_port         = 0
    to_port           = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# MySQL Cluster
resource "yandex_mdb_mysql_cluster" "netology_mysql" {
  name                = "netology-mysql-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.netology.id
  version             = var.mysql_version
  # deletion_protection = true

  resources {
    resource_preset_id = "b1.medium" 
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone      = var.default_zone[0]
    subnet_id = yandex_vpc_subnet.private[0].id
  }

  host {
    zone      = var.default_zone[1]
    subnet_id = yandex_vpc_subnet.private[1].id
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.netology_mysql.id
  name       = var.mysql_database
}

resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.netology_mysql.id
  name       = var.mysql_user
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

#### KMS Key
resource "yandex_kms_symmetric_key" "my_key" {
  name              = "my-symetric-key"
  description       = "My symetric key"
  default_algorithm = var.kms_default_algorithm
  rotation_period   = var.kms_rotation_period
}

# Сервис-аккаунт для кластера Kubernetes
resource "yandex_iam_service_account" "k8s_cluster_account" {
  name        = "${var.k8s_service_account_name}-cluster"
  description = "Service account for Kubernetes cluster"
}

# Сервис-аккаунт для узлов Kubernetes
resource "yandex_iam_service_account" "k8s_node_account" {
  name        = "${var.k8s_service_account_name}-nodes"
  description = "Service account for Kubernetes nodes"
}

# Роли для сервис-аккаунта кластера
resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_roles" {
  for_each = toset([
    "k8s.clusters.agent",
    "vpc.publicAdmin",
    "alb.editor",
    "kms.viewer",
    "kms.keys.encrypterDecrypter"
  ])

  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster_account.id}"
}

# Роли для сервис-аккаунта узлов
resource "yandex_resourcemanager_folder_iam_member" "k8s_node_roles" {
  for_each = toset([
    "container-registry.images.puller",
    "compute.viewer",
    "load-balancer.admin",
    "vpc.publicAdmin",
    "kms.viewer"
  ])

  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node_account.id}"
}

# Кластер Kubernetes
resource "yandex_kubernetes_cluster" "netology_k8s" {
  name        = var.k8s_cluster_name
  description = "Netology Kubernetes cluster"
  network_id  = yandex_vpc_network.netology.id

  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"
  node_ipv4_cidr_mask_size = 24

  service_account_id      = yandex_iam_service_account.k8s_cluster_account.id
  node_service_account_id = yandex_iam_service_account.k8s_node_account.id

  release_channel = "REGULAR"
  network_policy_provider = "CALICO"

  # KMS шифрование
  kms_provider {
    key_id = yandex_kms_symmetric_key.my_key.id
  }

  # Региональный мастер с нодами в трех подсетях
  master {
    regional {
      region = "ru-central1"

      location {
        zone      = var.default_zone[0]
        subnet_id = yandex_vpc_subnet.private[0].id
      }

      location {
        zone      = var.default_zone[1]
        subnet_id = yandex_vpc_subnet.private[1].id
      }

      location {
        zone      = var.default_zone[2]
        subnet_id = yandex_vpc_subnet.private[2].id
      }
    }

    version   = var.k8s_cluster_version
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "23:00"
        duration   = "3h"
      }
    }

    security_group_ids = [
      yandex_vpc_security_group.k8s_master_sg.id
    ]
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_cluster_roles,
    yandex_resourcemanager_folder_iam_member.k8s_node_roles
  ]
}

# Группа узлов с автомасштабированием
resource "yandex_kubernetes_node_group" "netology_node_group" {
  cluster_id = yandex_kubernetes_cluster.netology_k8s.id
  name       = "netology-node-group"
  version    = "1.32"

  instance_template {
    platform_id = "standard-v2"

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 10
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids = [
        yandex_vpc_subnet.private[0].id,
        yandex_vpc_subnet.private[1].id,
        yandex_vpc_subnet.private[2].id
      ]
      nat = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = var.default_zone[0]
    }
    location {
      zone = var.default_zone[1]
    }
    location {
      zone = var.default_zone[2]
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }

  deploy_policy {
    max_expansion   = 2
    max_unavailable = 1
  }
}
