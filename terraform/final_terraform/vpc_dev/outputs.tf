output "net_id" {
  value = yandex_vpc_network.finalter.id
}
output "subnet_id" {
  value = { for k, s in yandex_vpc_subnet.sub_finalter : k => s.id }
}

output "name" {
  value = { for k, s in yandex_vpc_subnet.sub_finalter : k => s.name }
}
output "zone" {
  value = { for k, s in yandex_vpc_subnet.sub_finalter : k => s.zone }
}
output "cidr" {
  value = { for k, s in yandex_vpc_subnet.sub_finalter: k => s.v4_cidr_blocks }
}

output "yandex_vpc_network_finalter_id" {
  value = yandex_vpc_network.finalter.id
}