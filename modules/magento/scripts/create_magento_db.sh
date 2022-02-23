#!/bin/bash

magentoschema="${magento_schema}"
magentoname="${magento_name}"


mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE DATABASE $magentoschema;"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE USER $magentoname identified by '${magento_password}';"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "GRANT ALL PRIVILEGES ON $magentoschema.* TO $magentoname;"

echo "Magento Database and User created !"
echo "MAGENTO USER = $magentoname"
echo "MAGENTO SCHEMA = $magentoschema"

