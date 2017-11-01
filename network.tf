resource "openstack_compute_floatingip_v2" "jumpbox_floating_ip" {
  pool = "${var.external_network}"
}

resource "openstack_networking_network_v2" "jumpbox_network" {
  region = "${var.os_region}"
  name = "${var.prefix}_nx_jumpbox_network"
}

resource "openstack_networking_subnet_v2" "jumpbox_subnet" {
  region = "${var.os_region}"
  name = "${var.prefix}_nx_jumpbox_subnet"
  network_id = "${openstack_networking_network_v2.jumpbox_network.id}"
  cidr = "${var.cidr}"
  gateway_ip = "${var.gateway}"
  dns_nameservers = "${var.dns}"
}

resource "openstack_networking_router_v2" "jumpbox_router" {
  region = "${var.os_region}"
  name = "${var.prefix}_nx_jumpbox_router"
  external_gateway = "${var.external_network_uuid}"
}

resource "openstack_networking_router_interface_v2" "jumpbox_router_interface" {
  region = "${var.os_region}"
  router_id = "${openstack_networking_router_v2.jumpbox_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.jumpbox_subnet.id}"
}

