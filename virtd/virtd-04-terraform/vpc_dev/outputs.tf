output "net_id" {
  value = yandex_vpc_network.develop.id
}
output "subnet_id" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.id }
}

output "name" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.name }
}
output "zone" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.zone }
}
output "cidr" {
  value = { for k, s in yandex_vpc_subnet.sub_develop : k => s.v4_cidr_blocks }
}