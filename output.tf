## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "magento_home_URL" {
  value = "http://${module.magento.public_ip[0]}/"
}

output "generated_ssh_private_key" {
  value     = module.magento.generated_ssh_private_key
  sensitive = true
}

output "magento_name" {
  value = var.magento_name
}

output "magento_password" {
  value = var.magento_password
}

output "magento_database" {
  value = var.magento_schema
}

output "mds_instance_ip" {
  value = module.mds-instance.mysql_db_system.ip_address
  sensitive = true
}