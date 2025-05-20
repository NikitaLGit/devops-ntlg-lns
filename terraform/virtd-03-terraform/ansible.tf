resource "local_file" "hosts_cfg" {
    content = <<-EOT
    %{if length(yandex_compute_instance.ter3count) > 0}
    [webservers]
    %{for i in yandex_compute_instance.ter3count}
    ${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
    %{endfor}
    %{endif}

    %{if length(yandex_compute_instance.ter3foreach) > 0}
    [databases]
    %{for s in yandex_compute_instance.ter3foreach}
    ${s["name"]} ansible_host=${s["network_interface"][0]["nat_ip_address"]} fqdn=${s["fqdn"]}
    %{endfor}
    %{endif}
 
    %{if length(yandex_compute_instance.storagevm) > 0}
    [storage]
    ${yandex_compute_instance.storagevm.name} ansible_host=${yandex_compute_instance.storagevm.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.storagevm.fqdn}
    %{endif}

    EOT
    filename = "${abspath(path.module)}/hosts.cfg"
}
