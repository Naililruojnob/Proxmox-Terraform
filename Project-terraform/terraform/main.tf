terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.42.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://proxmox.robert.local:8006/"
  api_token = var.api_token
  insecure = false
  ssh {
    agent    = true
    username = "root"
  }
}
