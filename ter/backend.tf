terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    region   = "ru-central1"
    bucket   = "bucket-terraform"
    key      = "ter/terraform.tfstate"
    access_key = "YCAJEzoXGtP6oCewOTp7lTULj"
    secret_key = "YCPm50G2vnDUvuLKUZfiT0-yoHdIiEu-fRO123AO"
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
