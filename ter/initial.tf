resource "yandex_compute_instance" "initial_vm" {
  name        = "initial"
 platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 2
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
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
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
