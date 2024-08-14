resource "yandex_container_registry" "registry" {
  name = "docker-registry"
  folder_id = var.folder_id
}
resource "yandex_container_registry_ip_permission" "my_ip_permission" {
  registry_id = yandex_container_registry.registry.id
  push = ["0.0.0.0/24", "89.169.174.252/24"]
  pull = ["0.0.0.0/24"]
}
