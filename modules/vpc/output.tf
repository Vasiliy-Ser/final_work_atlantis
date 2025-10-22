output "network_id" {
  value = yandex_vpc_network.project.id
}

output "subnet_ids" {
  value = { for k, v in yandex_vpc_subnet.subnets : k => v.id }
}

output "subnet_zones" {
  value = { for k, v in yandex_vpc_subnet.subnets : k => v.zone }
}

output "nat_gateway_id" {
  value       = one(yandex_vpc_gateway.nat_gateway[*].id)
  description = "NAT gateway ID (if created)"
}

output "route_table_id" {
  value       = one(yandex_vpc_route_table.nat_route[*].id)
  description = "ID route table (if created)"
}

output "security_group_id" {
  value = yandex_vpc_security_group.default.id
}