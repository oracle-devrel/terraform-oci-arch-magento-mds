#!/bin/bash
#set -x

chcon -R --type httpd_sys_rw_content_t /var/www/html/app/etc
chcon -R --type httpd_sys_rw_content_t /var/www/html/var
chcon -R --type httpd_sys_rw_content_t /var/www/html/pub/media
chcon -R --type httpd_sys_rw_content_t /var/www/html/pub/static
chcon -R --type httpd_sys_rw_content_t /var/www/html/generated

firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload

setsebool -P httpd_can_network_connect=1
setsebool -P httpd_can_network_connect_db 1

echo "Local Security Granted !"