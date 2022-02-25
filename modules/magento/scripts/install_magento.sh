#!/bin/bash
#set -x

export use_shared_storage='${use_shared_storage}'

if [[ $use_shared_storage == "true" ]]; then
  echo "Mount NFS share: ${magento_shared_working_dir}"
  yum install -y -q nfs-utils
  mkdir -p ${magento_shared_working_dir}
  echo '${mt_ip_address}:${magento_shared_working_dir} ${magento_shared_working_dir} nfs nosharecache,context="system_u:object_r:httpd_sys_rw_content_t:s0" 0 0' >> /etc/fstab
  setsebool -P httpd_use_nfs=1
  mount ${magento_shared_working_dir}
  mount
  echo "NFS share mounted."
  cd ${magento_shared_working_dir}
else
  echo "No mount NFS share. Moving to /var/www/html" 
  cd /var/www/html	
fi

magento_version=$(curl -s https://github.com/magento/magento2/releases/latest | grep -Po 'tag/\K.*' | cut -d'"' -f1)
wget https://github.com/magento/magento2/archive/$magento_version.tar.gz

if [[ $use_shared_storage == "true" ]]; then
  tar zxvf $magento_version.tar.gz --directory ${magento_shared_working_dir}
  cp -r ${magento_shared_working_dir}/magento2-$magento_version/* ${magento_shared_working_dir}
  rm -rf ${magento_shared_working_dir}/magento2-$magento_version
  rm -rf ${magento_shared_working_dir}/$magento_version.tar.gz
else
  tar zxvf $magento_version.tar.gz --directory /var/www/html
  cp -r /var/www/html/magento2-$magento_version/* /var/www/html
  rm -rf /var/www/html/magento2-$magento_version
  rm -rf /var/www/html/$magento_version.tar.gz
fi 

if [[ $use_shared_storage == "true" ]]; then
  echo "... Changing /etc/httpd/conf/httpd.conf with Document set to new shared NFS space ..."
  sed -i 's/"\/var\/www\/html"/"\${magento_shared_working_dir}"/g' /etc/httpd/conf/httpd.conf
  echo "... /etc/httpd/conf/httpd.conf with Document set to new shared NFS space ..."
  chown apache:apache -R ${magento_shared_working_dir}
  sed -i '/AllowOverride None/c\AllowOverride All' /etc/httpd/conf/httpd.conf
  #cp /home/opc/htaccess ${magento_shared_working_dir}/.htaccess
  #rm /home/opc/htaccess
  #cp /home/opc/index.html ${magento_shared_working_dir}/index.html
  #rm /home/opc/index.html
  chown apache:apache ${magento_shared_working_dir}/index.html
else
  chown apache:apache -R /var/www/html
  sed -i '/AllowOverride None/c\AllowOverride All' /etc/httpd/conf/httpd.conf
fi

cd /usr/local/bin
wget https://getcomposer.org/composer-1.phar
chmod +x composer-1.phar
mv composer-1.phar composer

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
  cp /home/opc/index.html ${magento_shared_working_dir}/index.html
  rm /home/opc/index.html
  chown apache:apache -R ${magento_shared_working_dir}
else 
  /var/www/html/bin/magento setup:install --no-ansi --db-host ${mds_ip}  --db-name ${magento_schema} --db-user ${magento_name} --db-password '${magento_password}' --admin-firstname='${magento_admin_firstname}' --admin-lastname='${magento_admin_lastname}' --admin-user='${magento_admin_login}' --admin-password='${magento_admin_password}' --admin-email='${magento_admin_email}'
  /var/www/html/bin/magento config:set web/unsecure/base_url http://${public_ip}/
  /var/www/html/bin/magento config:set web/secure/base_url https://${public_ip}/
  /var/www/html/bin/magento config:set web/secure/use_in_frontend 1
  /var/www/html/bin/magento config:set web/secure/use_in_adminhtml 0  
  chown apache:apache -R /var/www/html
fi

systemctl start httpd
systemctl enable httpd

echo "Magento deployed and Apache started !"