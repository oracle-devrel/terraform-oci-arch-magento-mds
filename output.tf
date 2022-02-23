## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "magento_public_ip" {
  value = module.magento.public_ip
}

output "magento_db_user" {
  value = var.magento_name
}

output "magento_db_password" {
  value = var.magento_password
}

output "mds_instance_ip" {
  value = module.mds-instance.private_ip
}

output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}

output "magento_admin_login" {
  value = var.magento_admin_login
}

output "magento_admin_password" {
  value = var.magento_admin_password
}

