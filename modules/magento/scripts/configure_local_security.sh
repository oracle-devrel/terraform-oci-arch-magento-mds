#!/bin/bash
#set -x

# Assuming you're using UFW (Uncomplicated Firewall) on Ubuntu for firewall management
ufw allow 80/tcp
ufw allow 443/tcp
ufw reload

# Ubuntu typically doesn't have SELinux enabled by default, but if you need similar file permission adjustments, you might use chown and chmod instead
chown -R www-data:www-data /var/www/html/app/etc
chown -R www-data:www-data /var/www/html/var
chown -R www-data:www-data /var/www/html/pub/media
chown -R www-data:www-data /var/www/html/pub/static
chown -R www-data:www-data /var/www/html/generated
chmod -R 755 /var/www/html

echo "Local Security Granted!"

