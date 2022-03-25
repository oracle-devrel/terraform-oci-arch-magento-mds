## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "magento_home_URL" {
  value = "http://${module.oci-arch-magento.public_ip[0]}/"
}

output "magento_backend_URL" {
  value = "http://${module.oci-arch-magento.public_ip[0]}/index.php/${var.magento_backend_frontname}/"
}

output "magento_backend_username" {
  value = "admin"
}

output "magento_backend_password" {
  value = var.magento_password
}

output "generated_ssh_private_key" {
  value     = module.oci-arch-magento.generated_ssh_private_key
  sensitive = true
}

output "mds_instance_ip" {
  value = module.mds-instance.mysql_db_system.ip_address
  sensitive = true
}