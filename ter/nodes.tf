resource "yandex_compute_instance" "node" {
  name        = "node-${count.index + 1}"
  count = 2
  platform_id = "standard-v2"
  zone = element(var.node_zones, count.index)
  resources {
    cores         = 4
    memory        = 4
    core_fraction = 5
   }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-ssd"
      size     = 15
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id = element([yandex_vpc_subnet.subnet2.id, yandex_vpc_subnet.subnet3.id], count.index)
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}
