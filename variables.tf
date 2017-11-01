variable "prefix" {}

variable "os_auth_url" { default = "" }
variable "os_username" { default = "" }
variable "os_password" { default = "" }
variable "os_domain_name" { default = "Default" }
variable "os_tenant" { default = "" } //OS_PROJECT_NAME if v3 auth
variable "os_region" {default = "RegionOne" }

variable "external_network" {}
variable "external_network_uuid" {}

variable "cidr" { default = "10.0.0.0/28" }
variable "gateway" { default = "10.0.0.1" }
variable "private_ip" { default = "10.0.0.3" }

variable "dns" { 
  type = "list"
  default = ["8.8.8.8", "8.8.4.4"]
}

variable "image" { default = "ubuntu-xenial" }
variable "flavor" { default = "m1.medium" }
variable "ssh_pubkey" { default = "~/.ssh/id_rsa.pub" }
variable "ssh_privkey" { default ="~/.ssh/id_rsa" }

variable "install_pkgs" {}
variable "nx_version" { default = "5.3.12_10" }
variable "nx_pubkey" { default = "" }
variable "post_deploy_script" { default = "" }
