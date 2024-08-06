variable "zone1" {
  type        = string
  default     = "ru-central1-a"
}

variable "zone2" {
  type        = string
  default     = "ru-central1-b"
}

variable "zone3" {
  type        = string
  default     = "ru-central1-d"
}

variable "cidr1" {
  type        = list(string)
  default     = ["10.0.5.0/24"]
}

variable "cidr2" {
  type        = list(string)
  default     = ["10.0.6.0/24"]
}

variable "cidr3" {
  type        = list(string)
  default     = ["10.0.7.0/24"]
}


variable "vpc_name" {
  type        = string
  default     = "network-diplom"
  description = "VPC network&subnet name"
}

variable "subnet1" {
  type        = string
  default     = "subnet1-diplom"
  description = "subnet name"
}

variable "subnet2" {
  type        = string
  default     = "subnet2-diplom"
  description = "subnet name"
}

variable "subnet3" {
  type        = string
  default     = "subnet3-diplom"
  description = "subnet name"
}
