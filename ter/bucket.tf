// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-stv.id
    description        = "static access key"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "bucket-terraform" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "bucket-terraform"
    acl    = "private"
    force_destroy = true

provisioner "local-exec" {
  command = "echo export ACCESS_KEY=${yandex_iam_service_account_static_access_key.sa-static-key.access_key} > /home/stv/ter/backend.tfvars"
}

provisioner "local-exec" {
  command = "echo export SECRET_KEY=${yandex_iam_service_account_static_access_key.sa-static-key.secret_key} >> /home/stv/ter/backend.tfvars"
}
}
