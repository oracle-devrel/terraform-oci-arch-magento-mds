## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
  vcn_id = var.existing_vcn_ocid == "" ? oci_core_virtual_network.magento_mds_vcn[0].id : var.existing_vcn_ocid
  internet_gateway_id = var.existing_internet_gateway_ocid == "" ? oci_core_internet_gateway.internet_gateway[0].id : var.existing_internet_gateway_ocid
  nat_gateway_id = var.existing_nat_gateway_ocid == "" ? oci_core_nat_gateway.nat_gateway[0].id : var.existing_nat_gateway_ocid
  public_route_table_id = var.existing_public_route_table_ocid == "" ? oci_core_route_table.public_route_table[0].id : var.existing_public_route_table_ocid
  private_route_table_id = var.existing_private_route_table_ocid == "" ? oci_core_route_table.private_route_table[0].id : var.existing_private_route_table_ocid
  private_subnet_id = var.existing_private_subnet_ocid == "" ? oci_core_subnet.private[0].id : var.existing_private_subnet_ocid
  public_subnet_id = var.existing_public_subnet_ocid == "" ? oci_core_subnet.public[0].id : var.existing_public_subnet_ocid
  private_security_list_id = var.existing_private_security_list_ocid == "" ? oci_core_security_list.private_security_list[0].id : var.existing_private_security_list_ocid
  public_security_list_id = var.existing_public_security_list_ocid == "" ? oci_core_security_list.public_security_list[0].id : var.existing_public_security_list_ocid
  private_security_list_opendistro_id = var.existing_private_security_list_opendistro_ocid == "" ? oci_core_security_list.private_security_list_opendistro[0].id : var.existing_private_security_list_opendistro_ocid
  public_security_list_http_id = var.existing_public_security_list_http_ocid == "" ? oci_core_security_list.public_security_list_http[0].id : var.existing_public_security_list_http_ocid
  ssh_key = var.ssh_authorized_keys_path == "" ? tls_private_key.public_private_key_pair.public_key_openssh : file(var.ssh_authorized_keys_path)
  ssh_private_key = var.ssh_private_key_path == "" ? tls_private_key.public_private_key_pair.private_key_pem : file(var.ssh_private_key_path)
  private_key_to_show = var.ssh_private_key_path == "" ? local.ssh_private_key : var.ssh_private_key_path
}