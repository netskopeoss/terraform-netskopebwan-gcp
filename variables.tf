#------------------------------------------------------------------------------
#  Copyright (c) 2022 Infiot Inc.
#  All rights reserved.
#------------------------------------------------------------------------------
##################################
## Profile and Region Variables ##
##################################
variable "gcp_profile" {
  description = "GCP Config Profile"
  type = object({
    project_id = string
    region     = optional(string, "us-west2")
    ssh_key    = optional(string, "")
  })
}

###############################
## GCP VPC Network Variables ##
###############################

variable "gcp_network_config" {
  description = "GCP VPC Details"
  type = object({
    ge1 = object({
      vpc_cidr = optional(string)
      vpc_name = optional(string)
      overlay  = optional(string, "public")
    })
    ge2 = optional(object({
      vpc_cidr = optional(string)
      vpc_name = optional(string)
      overlay  = optional(string)
    }), null)
    ge3 = optional(object({
      vpc_cidr = optional(string)
      vpc_name = optional(string)
      overlay  = optional(string)
    }), null)
    ge4 = optional(object({
      vpc_cidr = optional(string)
      vpc_name = optional(string)
      overlay  = optional(string)
    }), null)
    vpcs    = optional(any)
    subnets = optional(any)
  })
}

###########################
## GCP Compute Variables ##
###########################

variable "gcp_compute" {
  description = "GCP Instance Config"
  type = object({
    instance_type  = string
    image_id       = optional(string, "/projects/infiot-public-images/global/images/infiot-edge")
    primary_zone   = optional(string)
    secondary_zone = optional(string)
  })
  default = {
    instance_type = "n1-standard-4"
  }
}

variable "clients" {
  description = "Optional Client / Host VPC configuration"
  type = object({
    create_clients = optional(bool, false) # Blob to deploy optional Client in a new VPC for end to end testing.
    image_id       = optional(string, "projects/ubuntu-os-pro-cloud/global/images/ubuntu-pro-1804-bionic-v20221018")
    vpc_cidr       = optional(string, "192.168.255.0/28")
    instance_type  = optional(string, "n1-standard-2")
    password       = optional(string, "infiot")
    ports          = optional(list(string), ["3389", "22"])
  })
  default = {
    create_clients = false
  }
}

#######################
## GCP NCC Variables ##
#######################

variable "gcp_ncc_config" {
  description = "GCP NCC Details"
  type = object({
    create_cloud_router      = optional(bool, true)
    cloud_router_asn         = string
    cloud_rtr_custom_subnets = optional(list(string), [])
    cloud_router_iface1_ip   = optional(string, "")
    cloud_router_iface2_ip   = optional(string, "")
  })
}

###########################
## Netskope GW Variables ##
###########################

variable "netskope_tenant" {
  description = "Netskope Tenant Details"
  type = object({
    tenant_id      = string
    tenant_url     = string
    tenant_token   = string
    tenant_bgp_asn = optional(string, "400")
  })
}

variable "netskope_gateway_config" {
  description = "Netskope Gateway Details"
  type = object({
    ha_enabled       = optional(bool, false)
    gateway_password = optional(string, "infiot")
    gateway_policy   = optional(string, "Multicloud-GCP")
    gateway_name     = string
    gateway_model    = optional(string, "iXVirtual")
    gateway_role     = optional(string, "spoke")
    dns_primary      = optional(string, "8.8.8.8")
    dns_secondary    = optional(string, "8.8.4.4")
  })
}

variable "primary_gw_data" { # This will be computed during run
  type = object({
    id         = optional(string, "")
    token      = optional(string, "")
    userdata   = optional(string, "")
    bgp_metric = optional(string, "")
    public_ips = optional(any)
    interfaces = optional(any)
  })
  default = {
    bgp_metric = "10"
  }
}

variable "secondary_gw_data" { # This will be computed during run
  type = object({
    id         = optional(string, "")
    token      = optional(string, "")
    userdata   = optional(string, "")
    bgp_metric = optional(string, "")
    public_ips = optional(any)
    interfaces = optional(any)
  })
  default = {
    bgp_metric = "20"
  }
}
