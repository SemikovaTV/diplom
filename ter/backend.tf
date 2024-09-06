terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    region   = "ru-central1"
    bucket   = "bucket-terraform"
    key      = "terraform/state/terraform.tfstate"
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
