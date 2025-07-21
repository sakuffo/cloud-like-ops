variable "vm_name" {
  description = "Name for the VM"
  type        = string
}

variable "resource_pool_id" {
  description = "Resource pool ID"
  type        = string
}

variable "datastore_id" {
  description = "Datastore ID"
  type        = string
}

variable "network_id" {
  description = "Network ID"
  type        = string
}

variable "folder" {
  description = "VM folder path"
  type        = string
  default     = "/"
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

variable "guest_id" {
  description = "Guest OS ID"
  type        = string
}

variable "scsi_type" {
  description = "SCSI controller type"
  type        = string
}

variable "template_uuid" {
  description = "Template UUID to clone from"
  type        = string
}

variable "disk_eagerly_scrub" {
  description = "Eagerly scrub disk"
  type        = bool
  default     = false
}

variable "disk_thin_provisioned" {
  description = "Thin provision disk"
  type        = bool
  default     = true
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "local"
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