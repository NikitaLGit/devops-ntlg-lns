data "yandex_compute_instance_group" "dig_1" {
  instance_group_id = yandex_compute_instance_group.testing_ig.id
}

resource "yandex_lb_target_group" "lbtg_1" {
  name      = "target-group-1"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = data.yandex_compute_instance_group.dig_1.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = data.yandex_compute_instance_group.dig_1.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = data.yandex_compute_instance_group.dig_1.instances[2].network_interface[0].ip_address
  }
}

  resource "yandex_lb_network_load_balancer" "load_balancer_1" {
    name = "network-load-balancer-1"

    listener {
      name = "my-listener"
      port = 80
      external_address_spec {
        ip_version = "ipv4"
      }
    }

    attached_target_group {
      target_group_id = yandex_lb_target_group.lbtg_1.id

      healthcheck {
        name = "http"
        http_options {
          port = 80
          path = "/"
        }
      }
    }
  }