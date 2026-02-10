resource "yandex_iam_service_account" "instances" {
  name        = "instances"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "admin"
  members = [
    "serviceAccount:${yandex_iam_service_account.instances.id}",
  ]
  depends_on = [
    yandex_iam_service_account.instances,
  ]
}

resource "yandex_compute_instance_group" "testing_ig" {
  name                = "testing-ig"
  folder_id           = var.folder_id
  deletion_protection = false
  service_account_id  = yandex_iam_service_account.instances.id

  instance_template {
    platform_id = "standard-v1"
    name = "site-node-{instance.index}-{instance.short_id}"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 4
      }
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.subnet-1.id]
    }

    metadata = {
      user-data = file("index.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
  depends_on = [
    yandex_iam_service_account.instances, yandex_resourcemanager_folder_iam_binding.editor,
  ]
}
