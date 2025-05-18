output "net_id" {
  value = yandex_vpc_network.develop.id
}
output "subnet_id" {
  value = yandex_vpc_subnet.sub_develop.id
}

output "name" {
  value = yandex_vpc_subnet.sub_develop.name
}
output "zone" {
  value = yandex_vpc_subnet.sub_develop.zone
}
output "cidr" {
  value = yandex_vpc_subnet.sub_develop.v4_cidr_blocks
}