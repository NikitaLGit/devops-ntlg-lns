output "net_id" {
  value = yandex_vpc_network.production.id
}
output "subnet_id" {
  value = yandex_vpc_subnet.sub_prod.id
}

output "name" {
  value = yandex_vpc_subnet.sub_prod.name
}
output "zone" {
  value = yandex_vpc_subnet.sub_prod.zone
}
output "cidr" {
  value = yandex_vpc_subnet.sub_prod.v4_cidr_blocks
}