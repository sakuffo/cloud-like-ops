# Create the VM
resource "vsphere_virtual_machine" "ubuntu_nginx" {
  name             = var.vm_name
  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  folder           = var.folder

  num_cpus = var.vm_cpu
  memory   = var.vm_memory

  guest_id = var.guest_id

  scsi_type = var.scsi_type

  network_interface {
    network_id   = var.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    eagerly_scrub    = var.disk_eagerly_scrub
    thin_provisioned = var.disk_thin_provisioned
  }

  clone {
    template_uuid = var.template_uuid

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = var.domain
      }

      network_interface {
      }
    }
  }

  # Wait for the VM to be ready
  wait_for_guest_net_timeout  = 3     # Wait up to 5 minutes for network
  wait_for_guest_ip_timeout   = 3     # Wait up to 5 minutes for IP
  # wait_for_guest_net_routable = false # Don't wait for routable

  cdrom {
    client_device = true
  }

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
      "sudo apt update",
      "sudo apt install -y nginx",
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