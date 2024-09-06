output "internal_ip_address_master" {
  value = yandex_compute_instance.master-node.network_interface.0.ip_address
}
output "external_ip_address_master" {
  value = yandex_compute_instance.master-node.network_interface.0.nat_ip_address
}

output "internal_ip_address_initial_vm" {
  value = yandex_compute_instance.initial_vm.network_interface.0.ip_address
}

output "external_ip_address_initial_vm" {
  value = yandex_compute_instance.initial_vm.network_interface.0.nat_ip_address
}
output "vm_public_ips" {
  value       = [for instance in yandex_compute_instance.node : instance.network_interface.0.nat_ip_address]
}

output "vm_names" {
  description = "Список имён созданных ВМ"
  value       = [for instance in yandex_compute_instance.node : instance.name]
}
