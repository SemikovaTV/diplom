resource "yandex_compute_instance" "initial_vm" {
  name        = "initial-vm"
 platform_id = "standard-v1"
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
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
}
