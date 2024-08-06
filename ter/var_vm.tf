variable "name_vm1"{
  type        = string
  default     = "netology-develop-platform-web"
}

variable "name_vm2"{
  type        = string
  default     = "netology-develop-platform-db"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_os"{
  type        = string
  default     = "ubuntu-2404-lts"
}
