terraform {
  required_providers {
    proxmox = {
      source  = "danitso/Proxmox"
      version = "0.4.4"
    }
  }
}

# Define variables
variable "PROXMOX_PASSWORD" {
  description = "Proxmox API password"
  type        = string
}

provider "proxmox" {
  pm_api_url      = "https://192.168.0.3:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = var.PROXMOX_PASSWORD
  pm_tls_insecure = true
}

resource "proxmox_lxc" "example_lxc" {
  hostname   = "my-lxc-container"
  ostemplate = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst" # You can change this to your desired OS template
  storage    = "local"
  memory     = 512 # Memory in MB
  cores      = 1   # Number of CPU cores
  netif {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
  rootfs   = "local:2" # Define storage and size for rootfs (local:2 means 2GB)
  password = var.PROXMOX_PASSWORD
  swap     = 128 # Swap in MB
}
