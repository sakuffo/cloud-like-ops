# Output the module's outputs
output "vm_ip" {
  value = module.ubuntu_nginx_vm.vm_ip
}

output "vm_name" {
  value = module.ubuntu_nginx_vm.vm_name
}

output "nginx_url" {
  value = module.ubuntu_nginx_vm.nginx_url
}