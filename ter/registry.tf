resource "yandex_container_registry" "registry" {
  name = "docker-registry"
  folder_id = var.folder_id
}
resource "yandex_container_registry_ip_permission" "my_ip_permission" {
  registry_id = yandex_container_registry.registry.id
  push = ["10.0.5.0/24", "10.129.0.0/24"]
}
