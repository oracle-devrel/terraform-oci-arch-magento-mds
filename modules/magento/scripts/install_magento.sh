
#!/bin/bash
#set -x

export use_shared_storage='${use_shared_storage}'

if [[ $use_shared_storage == "true" ]]; then
  echo "Mount NFS share: ${magento_shared_working_dir}"
  apt-get install -y -qq nfs-common
  mkdir -p ${magento_shared_working_dir}
  echo '${mt_ip_address}:${magento_shared_working_dir} ${magento_shared_working_dir} nfs nosharecache,context="system_u:object_r:httpd_sys_rw_content_t:s0" 0 0' >> /etc/fstab
  mount ${magento_shared_working_dir}
  echo "NFS share mounted."
  install_path=${magento_shared_working_dir}
else
  echo "No mount NFS share. Moving to /var/www/html"
  install_path=/var/www/html
fi

cd /usr/local/bin
wget https://getcomposer.org/composer-1.phar
chmod +x composer-1.phar
mv composer-1.phar composer

/usr/local/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$magento_version $install_path

if [[ $use_shared_storage == "true" ]]; then
  echo "... Changing /etc/apache2/sites-available/000-default.conf with Document set to new shared NFS space ..."
  sed -i "s|/var/www/html|${magento_shared_working_dir}|g" /etc/apache2/sites-available/000-default.conf
  echo "... /etc/apache2/sites-available/000-default.conf with Document set to new shared NFS space ..."
  chown www-data:www-data -R ${magento_shared_working_dir}
else
  chown www-data:www-data -R /var/www/html
fi

if [[ $use_shared_storage == "true" ]]; then
  cd ${magento_shared_working_dir}   
else 
  cd /var/www/html
fi

/usr/local/bin/composer install

echo "Magento installed !"

if [[ $use_shared_storage == "true" ]]; then
  ${magento_shared_working_dir}/bin/magento setup:install --no-ansi --db-host ${mds_ip}  --db-name ${magento_schema} --db-user ${magento_name} --db-password '${magento_password}' --admin-firstname='${magento_admin_firstname}' --admin-lastname='${magento_admin_lastname}' --admin-user='${magento_admin_login}' --admin-password='${magento_admin_password}' --admin-email='${magento_admin_email}'
  ${magento_shared_working_dir}/bin/magento config:set web/unsecure/base_url http://${public_ip}/
  ${magento_shared_working_dir}/bin/magento config:set web/secure/base_url https://${public_ip}/
  ${magento_shared_working_dir}/bin/magento config:set web/secure/use_in_frontend 1
  ${magento_shared_working_dir}/bin/magento config:set web/secure/use_in_adminhtml 0
  cp /home/ubuntu/index.html ${magento_shared_working_dir}/index.html
  chown www-data:www-data -R ${magento_shared_working_dir}
else 
  /var/www/html/bin/magento setup:install --no-ansi --db-host ${mds_ip}  --db-name ${magento_schema} --db-user ${magento_name} --db-password '${magento_password}' --admin-firstname='${magento_admin_firstname}' --admin-lastname='${magento_admin_lastname}' --admin-user='${magento_admin_login}' --admin-password='${magento_admin_password}' --admin-email='${magento_admin_email}'
  /var/www/html/bin/magento config:set web/unsecure/base_url http://${public_ip}/
  /var/www/html/bin/magento config:set web/secure/base_url https://${public_ip}/
  /var/www/html/bin/magento config:set web/secure/use_in_frontend 1
  /var/www/html/bin/magento config:set web/secure/use_in_adminhtml 0
  chown www-data:www-data -R /var/www/html
fi

systemctl start apache2
systemctl enable apache2

echo "Magento deployed and Apache started !"

