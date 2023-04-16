
terraform {
  required_version = ">= 0.12"
    required_providers {
      openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.48.0"
    }
  }
}

provider openstack{
        user_name       = "admin"
        tenant_name     = "admin"
        password        = "secret"
        auth_url        = "http://172.30.1.17/identity"
}

resource "openstack_networking_network_v2" "private_1"{
        name            = "AAAA" 
        admin_state_up  = true
}

resource "openstack_networking_subnet_v2" "subnet_1"{
        name            ="subnet_1"
        network_id      ="${openstack_networking_network_v2.private_1.id}"
        cidr            ="10.0.0.0/24"
        ip_version      = 4
}

resource "openstack_compute_instance_v2" "test1" {
        name            = "test1"
        image_id        = "dce6200f-ee95-4085-a6a0-339d833cad0f"
        flavor_id       = "42"
        key_pair        = "test-key"
        security_groups = ["default"]

        network {
                name = "subnet_1"
        }
}
