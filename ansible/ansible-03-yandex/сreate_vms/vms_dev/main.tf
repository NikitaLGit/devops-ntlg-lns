data "terraform_remote_state" "vpc"{
  backend = "s3"
  config  = {
    bucket      = "ans-tfstate"
    key         = "ansible-03-test/vpc_dev/terraform.tfstate"
    endpoints   = { s3 = "https://storage.yandexcloud.net"}
    region      = "ru-central1"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
   }
}

resource "yandex_compute_instance" "ans_vms" {
    for_each = { for vm in var.each_vm : vm.vm_name => vm }

    name = each.value.vm_name
    platform_id = each.value.platform_id

    resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
    }

    boot_disk {
        initialize_params {
        image_id = each.value.boot_disk.image_id
        size     = each.value.boot_disk.size
        type     = each.value.boot_disk.type
            }
    }

    network_interface {
        subnet_id          = join(",", [for key, value in data.terraform_remote_state.vpc.outputs.subnet_id : "${value}"])
        nat                = each.value.network_interface.nat
    }

    scheduling_policy {
      preemptible = true
    }

    allow_stopping_for_update = true

    metadata = {
        ssh_name           = var.metadata_base.ssh_name
        user-data          = data.template_file.cloudinit.rendered
        serial-port-enable = var.metadata_base.serial-port-enable
        ssh-keys           = "${var.metadata_base.ssh_name}:${var.metadata_base.ssh_public_key}"
    }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_name       = var.metadata_base.ssh_name
    ssh_public_key = var.metadata_base.ssh_public_key
  }
}