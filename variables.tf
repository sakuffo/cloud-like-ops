# vSphere Connection Variables
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

# vSphere Infrastructure Variables
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

# VM Template Variables
variable "vm_template" {
  description = "Ubuntu VM template name"
  type        = string
  default     = "ubuntu-22.04-template"
}

# VM Configuration Variables
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

# SSH Variables
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