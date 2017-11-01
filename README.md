# terraform-nx-jumpbox

Quick and dirty terraform script to deploy a jumpbox running NX (NoMachine) on 
Openstack to have a remote desktop environment with whatever Window Manager of 
choice.

This configuration assumes Openstack is using v3 auth and requires a floating 
ip be able to be allocated.

# Deploy

## Set Inputs

Copy the `terraform.tfvars.example` file to `terraform.tfvars` :

```
cp terraform.tfvars.example terraform.tfvars
```

The following keys should be set at a minimum:

  - `prefix` - prefix to use for all created IaaS objects
  - `external_network` - name of the floating ip network
  - `external_network_uuid` - uud of the floating ip network
  - `os_auth_url` - openstack auth endpoint
  - `os_domain_name` - openstack auth domain name
  - `os_username` - openstack username
  - `os_passwork` - openstack password
  - `os_tenant` - openstack project name

### Optional IaaS variables

The following parameters have default values that can be overridden in the
tfvars file:

  - `cidr` - cidr for the jumpbox network [10.0.0.0/28]
  - `gateway` - gateway for the jumpbox network [10.0.0.1]
  - `private_ip` - private ip for the jumpbox [10.0.0.3]
  - `dns` - list of dns servers for the jumpbox network [[8.8.8.8, 8.8.4.4]]
  - `image` - glance image to use [ubuntu-xenial]
  - `flavor` - vm flavor to use [m1.small]

### SSH keys

An ssh keypair will be created in Openstack. Default user ssh keys will be
used (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`). To override, set the following
keys in your tfvars file:

```
ssh_pubkey = "<PATH_TO_SSH_PUBLIC_KEY>"
ssh_privkey = "<PATH_TO_SSH_PRIVATE_KEY>"
```

### Install Packages

Use the `install_pkg` variable in the tfvars file to set the name of all the 
packages to install when bringing the jumpbox. This should include the window 
manager you want NX to use, and can be any other packages that can be 
installed via `apt-get`. The packages should be passed in as a single string 
with each package name separated by a space. For example:

```
install_pkgs = "i3-wm i3status zsh git"
```

### NX Auth

By default NX will use the same keypair as you used for ssh. Another keypair 
may be specified if necessary setting the `nx_pubkey` in the tfvars file. 
The actual public key must be provided, not just a path:

```
nx_pubkey = "<SSH_PUBKEY>"
```

### Post-Deploy Script

An optional post-deploy script can be passed in to run after deployment. This
is useful for any one-off environment set-up that you may want to do. The 
path to the script should be set accordingly in your tfvars file:


```
post_deploy_script = "<PATH_TO_SCRIPT>"
```

## Deploy it

Check the plan for errors or oddities before deploying:

```
terraform plan
```

Let it rip:

```
terraform apply
```

# Clean-up

```
terraform destroy
```
