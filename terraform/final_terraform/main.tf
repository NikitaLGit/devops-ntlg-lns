terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.14.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
  }
  required_version = "~>1.9"
}

module "vpc_dev" {
  source    = "./vpc_dev"
  env_name  = var.vpc_name
  folder_id = var.folder_id
  subnets   = [
    { zone = "ru-central1-a", cidr = "10.0.10.0/24" }
  ]
}

module "lns_vm" {
  source         = "./vm_create"
  env_name       = var.vpc_name
  network_id     = module.vpc_dev.net_id
  subnet_zones   = values(module.vpc_dev.zone)
  subnet_ids     = values(module.vpc_dev.subnet_id)
  instance_name  = var.vms_resources.instance_name
  instance_count = var.vms_resources.instance_count
  image_family   = var.vms_resources.image_family
  public_ip      = var.vms_resources.public_ip
  
  yandex_vpc_network_finalter_id = module.vpc_dev.yandex_vpc_network_finalter_id
  
  folder_id = var.folder_id
  cloud_id = var.cloud_id
  zone = var.zone
  ssh_public_key = var.metadata_base.ssh_public_key

  labels = { 
    owner   = "n.leonov",
    project = "final_terraform"
     }

  metadata = {
    ssh-keys = "${var.metadata_base.ssh_name}:${var.metadata_base.ssh_public_key}"
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.metadata_base.serial-port-enable
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_name = var.metadata_base.ssh_name
    ssh_public_key = var.metadata_base.ssh_public_key
  }
}