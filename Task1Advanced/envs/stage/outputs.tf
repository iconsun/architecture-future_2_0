output "vm_id" {
  description = "ID ВМ в dev"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "Имя ВМ в dev"
  value       = module.vm.vm_name
}

output "vm_ip_address" {
  description = "Внешний IP адрес ВМ в dev"
  value       = module.vm.vm_ip_address
}

output "boot_disk_id" {
  description = "ID диска ВМ в dev"
  value       = module.vm.boot_disk_id
}
