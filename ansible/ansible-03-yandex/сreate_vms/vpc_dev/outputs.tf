output "net_id" {
  value = yandex_vpc_network.ans_net.id
}
output "subnet_id" {
  value = { for k, s in yandex_vpc_subnet.ans_subnet : k => s.id }
}

output "name" {
  value = { for k, s in yandex_vpc_subnet.ans_subnet : k => s.name }
}
output "zone" {
  value = { for k, s in yandex_vpc_subnet.ans_subnet : k => s.zone }
}
output "cidr" {
  value = { for k, s in yandex_vpc_subnet.ans_subnet: k => s.v4_cidr_blocks }
}

