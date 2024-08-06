resource "yandex_vpc_network" "network" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "subnet1" {
  name           = var.subnet1
  zone           = var.zone1
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.cidr1
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = var.subnet2
  zone           = var.zone2
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.cidr2
}

resource "yandex_vpc_subnet" "subnet3" {
  name           = var.subnet3
  zone           = var.zone3
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.cidr3
}
