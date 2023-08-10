#!/bin/bash
#set -x

# Update the package lists
sudo apt-get update

# Install software-properties-common to provide add-apt-repository
sudo apt-get install -y software-properties-common

# Add PHP repository
sudo add-apt-repository -y ppa:ondrej/php

# Add MySQL APT repository
wget https://dev.mysql.com/get/mysql-apt-config_0.8.17-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.17-1_all.deb
sudo apt-get update

# Install MySQL Shell
sudo apt-get install -y mysql-shell

# Create .mysqlsh directory
mkdir ~${user}/.mysqlsh
cp /usr/share/mysqlsh/prompt/prompt_256pl+aw.json ~${user}/.mysqlsh/prompt.json
echo '{
    "history.autoSave": "true",
    "history.maxSize": "5000"
}' > ~${user}/.mysqlsh/options.json
chown -R ${user} ~${user}/.mysqlsh

echo "MySQL Shell successfully installed !"

# Install PHP 8.2
sudo apt-get install -y php8.2 php8.2-cli php8.2-mysql php8.2-zip php8.2-gd php8.2-mbstring php8.2-xml php8.2-json php8.2-opcache php8.2-bcmath php8.2-soap php-pear

echo "MySQL Shell & PHP successfully installed !"

# Install Certbot and Apache mod_ssl
sudo apt-get install -y certbot apache2-utils

echo "Certbot has been installed !"

