## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

## DATASOURCE
# Init Script Files

locals {
  php_script           = "~/install_php74.sh"
  magento_script       = "~/install_magento.sh"
  create_magento_db    = "~/create_magento_db.sh"
  security_script      = "~/configure_local_security.sh"
}

data "template_file" "install_magento" {
  template = file("${path.module}/scripts/install_magento.sh")

  vars = {
    magento_name            = var.magento_name
    magento_password        = var.magento_password
    magento_schema          = var.magento_schema
    mds_ip                  = var.mds_ip
    magento_admin_login     = var.magento_admin_login
    magento_admin_password  = var.magento_admin_password
    magento_admin_firstname = var.magento_admin_firstname
    magento_admin_lastname  = var.magento_admin_lastname
    magento_admin_email     = var.magento_admin_email
  }
}

data "template_file" "install_php" {
  template = file("${path.module}/scripts/install_php74.sh")

  vars = {
    mysql_version         = var.mysql_version,
    user                  = var.vm_user
  }
}

data "template_file" "configure_local_security" {
  template = file("${path.module}/scripts/configure_local_security.sh")
}

data "template_file" "create_magento_db" {
  template = file("${path.module}/scripts/create_magento_db.sh")
  count    = var.nb_of_webserver
  vars = {
    admin_password   = var.admin_password
    admin_username   = var.admin_username
    magento_name     = var.magento_name
    magento_password = var.magento_password
    magento_schema   = var.magento_schema
    mds_ip           = var.mds_ip
    dedicated       = var.dedicated
    instancenb      = count.index+1
  }
}

resource "oci_core_instance" "Magento" {
  count               = var.nb_of_webserver
  defined_tags        = var.defined_tags
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}${count.index+1}"
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus = var.flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}${count.index+1}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = "${var.display_name}${count.index+1}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.install_magento.rendered
    destination = local.magento_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

 provisioner "file" {
    content     = data.template_file.create_magento_db[count.index].rendered
    destination = local.create_magento_db

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }


   provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }

    inline = [
       "chmod +x ${local.php_script}",
       "sudo ${local.php_script}",
       "chmod +x ${local.create_magento_db}",
       "sudo ${local.create_magento_db}",
       "chmod +x ${local.magento_script}",
       "sudo ${local.magento_script}",
       "chmod +x ${local.security_script}",
       "sudo ${local.security_script}"
    ]

   }

  timeouts {
    create = "10m"

  }
}