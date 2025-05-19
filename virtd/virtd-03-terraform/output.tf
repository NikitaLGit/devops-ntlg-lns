output "all_vms" {
  value = [
    {webservers = [for i in yandex_compute_instance.ter3count : "\"name\" = \"${i.name}\"\n\"id\" = \"${i.id}\"\n\"fqdn\" = \"${i.fqdn}\""]},
    {databases = [for i in yandex_compute_instance.ter3foreach : "\"name\" = \"${i.name}\"\n\"id\" = \"${i.id}\"\n\"fqdn\" = \"${i.fqdn}\""]},
    {storage = ["\"name\" = \"${yandex_compute_instance.storagevm.name}\"\n\"id\" = \"${yandex_compute_instance.storagevm.id}\"\n\"fqdn\" = \"${yandex_compute_instance.storagevm.fqdn}\""]}
    ]
}