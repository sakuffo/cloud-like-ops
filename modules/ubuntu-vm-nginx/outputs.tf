output "vm_ip" {
  value       = vsphere_virtual_machine.ubuntu_nginx.default_ip_address
  description = "The IP address of the VM"
}

output "vm_name" {
  value       = vsphere_virtual_machine.ubuntu_nginx.name
  description = "The name of the VM"
}

output "vm_id" {
  value       = vsphere_virtual_machine.ubuntu_nginx.id
  description = "The ID of the VM"
}

output "nginx_url" {
  value       = "http://${vsphere_virtual_machine.ubuntu_nginx.default_ip_address}"
  description = "The URL to access nginx"
}