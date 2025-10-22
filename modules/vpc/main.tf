terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.146.0"
    }
  }
  required_version = ">=1.8.4"
}

# resource "yandex_vpc_network" "project" {
#   name = var.name
# }

data "yandex_vpc_network" "project" {
  name = var.name  
}

# NAT Gateway (optional)
resource "yandex_vpc_gateway" "nat_gateway" {
  count = var.enable_nat ? 1 : 0

  name = "${var.name}-nat-gateway"
  shared_egress_gateway {}
}

# Internet access route table
resource "yandex_vpc_route_table" "nat_route" {
  count = var.enable_nat ? 1 : 0

  name       = "${var.name}-nat-route"
  network_id = data.yandex_vpc_network.project.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway[0].id
  }
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = var.subnets

  name           = "${var.name}-${each.key}"
  zone           = each.value.zone
  network_id     = data.yandex_vpc_network.project.id
  v4_cidr_blocks = [each.value.cidr]

  # all subnets are connected to one route table
  route_table_id = var.enable_nat ? yandex_vpc_route_table.nat_route[0].id : null
}

# resource "yandex_vpc_subnet" "subnets" {
#   for_each = var.subnets

#   name           = "${var.name}-${each.key}"
#   zone           = each.value.zone
#   network_id     = yandex_vpc_network.project.id
#   v4_cidr_blocks = [each.value.cidr]

#   # Corrected syntax - all in one line
#   route_table_id = each.value.public && var.enable_nat ? yandex_vpc_route_table.nat_route[0].id : yandex_vpc_route_table.private_route.id
# }

# resource "yandex_vpc_subnet" "metallb" {
#   name           = "metallb-subnet"
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.project.id
#   v4_cidr_blocks = ["10.10.10.0/24"]
# }