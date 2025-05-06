output "test" {

  value = [
    { platform = ["platform: instanse_name is ${yandex_compute_instance.platform.name}; fqdn is ${yandex_compute_instance.platform.fqdn}; external ip is ${yandex_compute_instance.platform.network_interface[0].nat_ip_address}"]},
    { database = ["database: instanse_name is ${yandex_compute_instance.database.name}; fqdn is ${yandex_compute_instance.database.fqdn}; external ip is ${yandex_compute_instance.database.network_interface[0].nat_ip_address}"]}
  ]
}