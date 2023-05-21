terraform {
    required_version =">= 0.12"
    required_providers {
        openstack = {
            source     = "terraform-provider-openstack/openstack"
            version    = "~> 1.48.0"
        }
    }
}
provider openstack {
    user_name        = "admin"
    tenant_name        = "admin"
    password        = "secret"
    auth_url        = "http://121.135.134.175//identity"
}
# Image creation
resource "openstack_images_image_v2" "ubuntu1404" {
    name                = "ubuntu1404"
    local_file_path        = "/opt/stack/IaC/trusty-server-cloudimg-amd64-disk1.img"
    container_format    = "bare"
    disk_format            = "qcow2"
}
# Router creation
resource "openstack_networking_router_v2" "router_1" {
    name                = "router_1"
    external_network_id    = "28b2be49-04b2-416e-bf4d-2453fe77c450"
}
# Network creation
resource "openstack_networking_network_v2" "private_1"{
    name            = "private_1"
    admin_state_up    = true
}
# Subnet creation
resource "openstack_networking_subnet_v2" "subnet_1" {
    name        = "subnet_1"
    network_id    = openstack_networking_network_v2.private_1.id
    cidr        = "10.0.0.0/24"
    ip_version= 4
	dns_nameservers	= ["8.8.8.8","8.8.4.4"]
}
# Connect subnet and external network 
resource "openstack_networking_router_interface_v2" "interface_1"{
    router_id    = openstack_networking_router_v2.router_1.id
    subnet_id    = openstack_networking_subnet_v2.subnet_1.id
}
#Modified code with updated rules
resource "openstack_compute_secgroup_v2" "ssh" {
    name            = "ssh"
    description        = "Open input ssh port"
    rule {
        from_port    = 22
        to_port        = 22
        ip_protocol    = "tcp"
        cidr        = "0.0.0.0/0"
    }
}
resource "openstack_compute_secgroup_v2" "http" {
	name		= "http"
	description	= "Open input http port"
	rule {
		from_port	= 80
		to_port		= 80
		ip_protocol	="tcp"
		cidr		="0.0.0.0/0"
	}
}

resource "openstack_networking_port_v2" "http" {
    name                = "port-instance-http"
    network_id            = openstack_networking_network_v2.private_1.id
    admin_state_up        = true
    security_group_ids     = [
        openstack_compute_secgroup_v2.ssh.id,
		openstack_compute_secgroup_v2.http.id
    ]
    fixed_ip {
        subnet_id         = openstack_networking_subnet_v2.subnet_1.id
    }
}
resource "openstack_networking_floatingip_v2" "http"{
    pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "http" {
    floating_ip    = openstack_networking_floatingip_v2.http.address
    instance_id    = openstack_compute_instance_v2.instance_1.id
}

resource "openstack_compute_instance_v2" "instance_1" {
    name            = "instance_1"
    image_id        = openstack_images_image_v2.ubuntu1404.id
    flavor_id       = "2"

    user_data        = file("instance_1.sh")

    network {
        port        = openstack_networking_port_v2.http.id
    }
}

resource "openstack_compute_instance_v2" "instance_2" {
	name			= "instance"
}

