// Create SA
resource "yandex_iam_service_account" "sa-stv" {
    name      = "sa-stv"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "terraform-editor" {
    folder_id = var.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-stv.id}"
    depends_on = [yandex_iam_service_account.sa-stv]
}
