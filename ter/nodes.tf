resource "yandex_compute_instance" "node-1" {
  name        = "node-1"
  platform_id = "standard-v1"
  zone = var.zone2
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
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}
resource "yandex_compute_instance" "node-2" {
  name        = "node-2"
  platform_id = "standard-v2"
  zone = var.zone3
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
    subnet_id = yandex_vpc_subnet.subnet3.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}
