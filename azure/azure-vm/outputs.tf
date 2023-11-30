output "public_ip" {
   value       = azurerm_linux_virtual_machine.vm_inst.public_ip_address
   description = "Azure VM public IP"
}

output "arcadia_port" {
   value       = 8080
   description = "Arcadia application opened port"
}
