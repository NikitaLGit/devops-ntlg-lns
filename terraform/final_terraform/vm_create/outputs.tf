output "external_ip_address" {
  value = yandex_compute_instance.vm.*.network_interface.0.nat_ip_address
}

output "internal_ip_address" {
  value = yandex_compute_instance.vm.*.network_interface.0.ip_address
}

output "fqdn" {
  value = yandex_compute_instance.vm.*.fqdn
}

output "labels" {
  value = yandex_compute_instance.vm.*.labels
}

output "network_interface" {
  value = yandex_compute_instance.vm.*.network_interface
}
