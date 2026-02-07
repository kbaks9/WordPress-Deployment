#!/bin/bash
# To test and debug remove # below
# echo "Script running..." > /tmp/test.txt

# log output (start capturing logs immediately)
exec > /var/log/wordpress-install.log 2>&1

# Variables
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="easypass333"

# Update system
apt update -y
apt upgrade -y

# Install Apache, PHP, MySQL, and dependencies
apt install apache2 mysql-server php php-mysql php-xml php-gd php-curl php-zip php-mbstring unzip curl -y

# Enable and start services
systemctl enable apache2
systemctl start apache2
systemctl enable mysql
systemctl start mysql

# Drop existing WordPress DB if exists
mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"
rm -rf /var/www/html/*

# Create MySQL database and user
mysql -e "CREATE DATABASE ${DB_NAME};"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Download Wordpress and save it
wget https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz

# Extract WordPress to the web directory
tar -xzvf /tmp/latest.tar.gz -C /var/www/html --strip-components=1

# Remove default Apache index.html
sudo rm /var/www/html/index.html

# Clean up the tarball
rm /tmp/latest.tar.gz

# Copy this sample file 
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Modify config
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$DB_PASS/" /var/www/html/wp-config.php

# Add Wordpress security salt
wget -qO- https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php

# Set permissions
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "WordPress installation script completed!"
echo "Visit http://YOUR_VM_IP in your browser to finish setup."