resource "openstack_compute_keypair_v2" "keypair" {
  name = "${var.prefix}_nx_jumpbox"
  public_key =  "${chomp(file("${var.ssh_pubkey}"))}"
}

resource "openstack_compute_instance_v2" "jumpbox" {
  region = "${var.os_region}"
  name = "${var.prefix}_nx_jumpbox"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  security_groups = ["${openstack_networking_secgroup_v2.jumpbox_secgroup.name}"]
  key_pair = "${openstack_compute_keypair_v2.keypair.name}"

  network {
    name = "${openstack_networking_network_v2.jumpbox_network.name}"
    fixed_ip_v4 = "${var.private_ip}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "jumpbox_public_ip" {
  depends_on = ["openstack_networking_secgroup_rule_v2.ssh"]

  floating_ip = "${openstack_compute_floatingip_v2.jumpbox_floating_ip.address}"
  instance_id = "${openstack_compute_instance_v2.jumpbox.id}"
  fixed_ip = "${openstack_compute_instance_v2.jumpbox.network.0.fixed_ip_v4}"
}

resource "null_resource" "install_packages" {
  triggers {
    floating_ip_associated = "${openstack_compute_floatingip_associate_v2.jumpbox_public_ip.floating_ip}"
  }

  connection {
    type = "ssh"
    host = "${openstack_compute_floatingip_v2.jumpbox_floating_ip.address}"
    user = "ubuntu"
    private_key = "${chomp(file("${var.ssh_privkey}"))}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y xvfb ${var.install_pkgs}",
      # TODO Do versioning better for NX download
      "wget -O /tmp/nx-${var.nx_version}.deb http://download.nomachine.com/download/5.3/Linux/nomachine_${var.nx_version}_amd64.deb",
      "sudo dpkg -i /tmp/nx-${var.nx_version}.deb",
      "mkdir -p ~/.nx/config",
      "echo \"${var.nx_pubkey == "" ? openstack_compute_keypair_v2.keypair.public_key : var.nx_pubkey}\" > ~/.nx/config/authorized.crt"
    ]
  }
}

resource "null_resource" "post_deploy_script" {
  count = "${var.post_deploy_script == "" ? 0 : 1}"

  triggers {
    deployment_done = "${null_resource.install_packages.id}"
  }

  connection {
    type = "ssh"
    host = "${openstack_compute_floatingip_v2.jumpbox_floating_ip.address}"
    user = "ubuntu"
    private_key = "${chomp(file("${var.ssh_privkey}"))}"
  }

  provisioner "remote-exec" {
    script = "${var.post_deploy_script}"
  }
}
