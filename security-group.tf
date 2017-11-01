resource "openstack_networking_secgroup_v2" "jumpbox_secgroup" {
  name = "${var.prefix}_nx_jumpbox_secgroup"
  description = "Security Group for VNC jumpbox (${var.prefix})"
  region = "${var.os_region}"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = "${openstack_networking_secgroup_v2.jumpbox_secgroup.id}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "nx" {
  security_group_id = "${openstack_networking_secgroup_v2.jumpbox_secgroup.id}"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 4000
  port_range_max = 4000
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  security_group_id = "${openstack_networking_secgroup_v2.jumpbox_secgroup.id}"
  remote_ip_prefix = "0.0.0.0/0"
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
}
