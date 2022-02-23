## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "magento" {
  source                  = "./modules/magento"
  availability_domain     = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  display_name            = var.magento_instance_name
  compartment_ocid        = var.compartment_ocid
  image_id                = var.node_image_id == "" ? data.oci_core_images.images_for_shape.images[0].id : var.node_image_id
  shape                   = var.node_shape
  label_prefix            = var.label_prefix
  subnet_id               = local.public_subnet_id
  mds_ip                  = module.mds-instance.private_ip
  admin_password          = var.admin_password
  admin_username          = var.admin_username
  magento_schema          = var.magento_schema
  magento_name            = var.magento_name
  magento_password        = var.magento_password
  nb_of_webserver         = var.nb_of_webserver
  flex_shape_ocpus        = var.node_flex_shape_ocpus
  flex_shape_memory       = var.node_flex_shape_memory
  ssh_authorized_keys     = local.ssh_key
  ssh_private_key         = local.ssh_private_key
  magento_admin_login     = var.magento_admin_login
  magento_admin_password  = var.magento_admin_password
  magento_admin_firstname = var.magento_admin_firstname
  magento_admin_lastname  = var.magento_admin_lastname
  magento_admin_email     = var.magento_admin_email
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }  
}
