# Configure the vSphere Provider
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

# Configure the vSphere Provider
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

# Data sources
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Use the ubuntu-vm-nginx module
module "ubuntu_nginx_vm" {
  source = "./modules/ubuntu-vm-nginx"

  vm_name          = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  network_id       = data.vsphere_network.network.id

  vm_cpu       = var.vm_cpu
  vm_memory    = var.vm_memory
  vm_disk_size = var.vm_disk_size

  guest_id      = data.vsphere_virtual_machine.template.guest_id
  scsi_type     = data.vsphere_virtual_machine.template.scsi_type
  template_uuid = data.vsphere_virtual_machine.template.id

  disk_eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
}

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