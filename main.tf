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

# Variables
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "cluster" {
  description = "vSphere cluster"
  type        = string
}

variable "datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "network" {
  description = "vSphere network"
  type        = string
}

variable "vm_template" {
  description = "Ubuntu VM template name"
  type        = string
  default     = "ubuntu-22.04-template"
}

variable "vm_name" {
  description = "Name for the VM"
  type        = string
  default     = "ubuntu-nginx-vm"
}

variable "vm_cpu" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "ssh_username" {
  description = "SSH username for the VM"
  type        = string
  default     = "ubuntu"
}

variable "ssh_password" {
  description = "SSH password for the VM"
  type        = string
  sensitive   = true
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

# Create the VM
resource "vsphere_virtual_machine" "ubuntu_nginx" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "/"

  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "local"
      }

      network_interface {
        ipv4_address = ""
        ipv4_netmask = ""
      }
    }
  }

  # Wait for the VM to be ready
  wait_for_guest_net_timeout = 5  # Wait up to 5 minutes for network
  wait_for_guest_ip_timeout  = 5  # Wait up to 5 minutes for IP

  connection {
    type     = "ssh"
    user     = var.ssh_username
    password = var.ssh_password
    host     = self.default_ip_address
    timeout  = "10m"
  }

  # Wait for SSH to be ready
  provisioner "remote-exec" {
    inline = [
      "echo 'VM is ready for provisioning'"
    ]
  }

  # Install nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl status nginx"
    ]
  }

  # Optional: Configure firewall
  provisioner "remote-exec" {
    inline = [
      "sudo ufw allow 'Nginx Full'",
      "sudo ufw --force enable"
    ]
  }
}

# Output the VM's IP address
output "vm_ip" {
  value = vsphere_virtual_machine.ubuntu_nginx.default_ip_address
}

output "vm_name" {
  value = vsphere_virtual_machine.ubuntu_nginx.name
}

output "nginx_url" {
  value = "http://${vsphere_virtual_machine.ubuntu_nginx.default_ip_address}"
}