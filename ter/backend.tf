terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    region   = "ru-central1"
    bucket   = "bucket-terraform"
    key      = "ter/terraform.tfstate"
    access_key = "YCA..."
    secret_key = "YCOWQ4..."
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
