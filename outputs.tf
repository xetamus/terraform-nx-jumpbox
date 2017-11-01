output "Jumpbox IP" {
  value = "${openstack_compute_floatingip_associate_v2.jumpbox_public_ip.floating_ip}"
}
