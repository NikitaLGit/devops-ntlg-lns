output "all_vms" {
  value = [
    {test = ["platform: instanse_name is ${yandex_compute_instance.ter3foreach[each.key].name};\nfqdn is ${yandex_compute_instance.ter3foreach[each.key].fqdn};\nexternal ip is ${yandex_compute_instance.ter3foreach.network_interface[0][each.key].nat_ip_address}"]}
    ]
}