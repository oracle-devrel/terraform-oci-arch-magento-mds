## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "mysql_version" {
  description = "The version of the Mysql Shell."
  default     = "8.0.28"
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "availability_domain" {
  description = "The Availability Domain of the instance."
  default     = ""
}

variable "display_name" {
  description = "The name of the instance. "
  default     = ""
}

variable "subnet_id" {
  description = "The OCID of the Shell subnet to create the VNIC for public access. "
  default     = ""
}

variable "shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard2.1"
}

variable "label_prefix" {
  description = "To create unique identifier for multiple clusters in a compartment."
  default     = ""
}

variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address. Default 'false' do not assign a public IP address. "
  default     = true
}

variable "image_id" {
  description = "The OCID of an image for an instance to use. "
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}


variable "magento_schema" {
  description = "Magento MySQL Schema"
}

variable "admin_username" {
    description = "Username od the MDS admin account"
}


variable "admin_password" {
    description = "Password for the admin user for MDS"
}

variable "mds_ip" {
    description = "Private IP of the MDS Instance"
}

variable "nb_of_webserver" {
    description = "Amount of Webservers to deploy"
    default = 1
}

variable "use_AD" {
  description = "Using different Availability Domain, by default use of Fault Domain"
  type        = bool
  default     = false
}

variable "dedicated" {
  description = "Create a dedicated user and a dedicated database for each Webservers"
  type        = bool
  default     = false
}

variable "flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 6
}

locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex",
    "VM.Standard3.Flex",
    "VM.Standard4.Flex"   
  ]
}

locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.shape)
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
  default     = ""
}

variable "ssh_private_key" {
  description = "The private key path to access instance. "
  default     = ""
}

variable "magento_name" {
  description = "Magento Database User Name."
}

variable "magento_password" {
  description = "Magento Database User Password."
}


variable "web_ip" {
  description = "IP of the Web Instance."
  default     = ""
}


variable "magento_admin_login" {
  description = "Magento Admin Username"
  default     = "admin"
}

variable "magento_admin_password" {
  description = "Magento Admin Password"
  default     = "AdminPassw0rd!"
}

variable "magento_admin_firstname" {
  description = "Magento Admin Firstname"
  default     = "Mangento"
}

variable "magento_admin_lastname" {
  description = "Magento Admin Lastname"
  default     = "Admin"
}

variable "magento_admin_email" {
  description = "Magento Admin Email"
}

variable "defined_tags" {
  description = "Defined tags for WordPress host."
  default     = ""
}
