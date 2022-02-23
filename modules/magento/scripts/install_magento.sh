#!/bin/bash
#set -x

cd /var/www/

magento_version=$(curl -s https://github.com/magento/magento2/releases/latest | grep -Po 'tag/\K.*' | cut -d'"' -f1)
wget https://github.com/magento/magento2/archive/$magento_version.tar.gz
tar zxvf $magento_version.tar.gz
rm -rf html/ $magento_version.tar.gz
mv magento2-* html


chown apache. -R html
sed -i '/AllowOverride None/c\AllowOverride All' /etc/httpd/conf/httpd.conf


cd /usr/local/bin
wget https://getcomposer.org/composer-1.phar
chmod +x composer-1.phar
mv composer-1.phar composer
cd /var/www/html
/usr/local/bin/composer install

echo "Magento installed !"

cd /var/www/html

bin/magento setup:install --no-ansi --db-host ${mds_ip}  --db-name ${magento_schema} --db-user ${magento_name} --db-password '${magento_password}' --admin-firstname='${magento_admin_firstname}' --admin-lastname='${magento_admin_lastname}' --admin-user='${magento_admin_login}' --admin-password='${magento_admin_password}' --admin-email='${magento_admin_email}'

cd /var/www
chown apache. -R html

systemctl start httpd
systemctl enable httpd

echo "Magento deployed and Apache started !"