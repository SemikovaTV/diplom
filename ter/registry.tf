resource "yandex_container_registry" "registry" {
  name = "docker-registry"
  folder_id = var.folder_id
  labels = {
    my-label = "my-label-value"
  }
}
