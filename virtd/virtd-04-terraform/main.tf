#создаем облачную сеть
# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }

# #создаем подсеть
# resource "yandex_vpc_subnet" "develop_a" {
#   name           = var.default_sub_a.name
#   zone           = var.default_sub_a.zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = [var.default_sub_a.cidr]
# }

resource "yandex_vpc_subnet" "develop_b" {
  name           = var.default_sub_b.name
  zone           = var.default_sub_b.zone
  network_id     = "${module.vpc_create.net_id}"
  v4_cidr_blocks = [var.default_sub_b.cidr]
}

module "vpc_create" {
  source         = "./.terraform/modules/vpc"
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.vpc_name
  network_id     = "${module.vpc_create.net_id}"
  subnet_zones   = ["${module.vpc_create.zone}", var.default_sub_b.zone]
  subnet_ids     = ["${module.vpc_create.subnet_id}",yandex_vpc_subnet.develop_b.id]
  instance_name  = var.vms_resources.test.instance_name
  instance_count = var.vms_resources.test.instance_count
  image_family   = var.vms_resources.test.image_family
  public_ip      = var.vms_resources.test.public_ip

  labels = { 
    owner   = "n.leonov",
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = var.metadata_base.serial-port-enable
  }

}

module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.vpc_name
  network_id     = "${module.vpc_create.net_id}"
  subnet_zones   = ["${module.vpc_create.zone}"]
  subnet_ids     = ["${module.vpc_create.subnet_id}"]
  instance_name  = var.vms_resources.example.instance_name
  instance_count = var.vms_resources.example.instance_count
  image_family   = var.vms_resources.example.image_family
  public_ip      = var.vms_resources.example.public_ip

  labels = { 
    owner   = "n.leonov",
    project = "analytics"
    }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = var.metadata_base.serial-port-enable
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key = var.metadata_base.ssh_public_key
  }
}
