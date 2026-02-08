#!/bin/bash
# Use Bash shell to execute this script

# Exit immediately if any command fails (prevents partial or silent failures)
set -e

# Redirect all standard output and errors to a log file for auditing and debugging
exec > /var/log/wordpress-install.log 2>&1

# Log the start time of the bootstrap process
echo "BOOTSTRAP STARTED at $(date)"

# -------------------------
# Database configuration
# -------------------------

# Name of the WordPress database.
# Database user that WordPress will authenticate as.
# Database password (acceptable for labs; use a secrets manager in production).
DB_NAME="wordpress"         ### Change it to what you like
DB_USER="wpuser"            ### Change it to what you like
DB_PASS="easypass333"       ### Change it to what you like

# -------------------------
# System preparation
# -------------------------

# Update the local package index to ensure latest package versions are installed
apt-get update -y

# Install Apache (web server), MySQL (database),
# PHP, and required PHP extensions for WordPress
apt-get install -y \
  apache2 \
  mysql-server \
  php \
  php-mysql \
  php-xml \
  php-gd \
  php-curl \
  php-zip \
  php-mbstring \
  unzip \
  curl \
  wget

# -------------------------
# Service management
# -------------------------

# Enable Apache to start automatically on system boot
systemctl enable apache2

# Start Apache service immediately
systemctl start apache2

# Enable MySQL to start automatically on system boot
systemctl enable mysql

# Start MySQL service immediately
systemctl start mysql

# -------------------------
# Ensure MySQL is ready
# -------------------------

# Wait until MySQL is fully initialised and accepting connections
until mysqladmin ping --silent; do
  sleep 2
done

# -------------------------
# Database setup
# -------------------------

# Remove any existing WordPress database to allow safe re-runs of the script
mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"

# Create the WordPress database
mysql -e "CREATE DATABASE ${DB_NAME};"

# Create the WordPress database user if it does not already exist
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"

# Grant full privileges on the WordPress database to the WordPress user
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"

# Apply and persist MySQL privilege changes
mysql -e "FLUSH PRIVILEGES;"

# -------------------------
# WordPress installation
# -------------------------

# Remove default Apache files from the web root
rm -rf /var/www/html/*

# Download the latest WordPress release archive quietly
wget -q https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz

# Extract WordPress into the Apache web root
# --strip-components=1 removes the top-level 'wordpress' directory
tar -xzf /tmp/wp.tar.gz -C /var/www/html --strip-components=1

# Remove the downloaded archive to free disk space
rm /tmp/wp.tar.gz

# -------------------------
# WordPress configuration
# -------------------------

# Copy the sample WordPress configuration file
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Inject the database name into wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php

# Inject the database username into wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php

# Inject the database password into wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wp-config.php

# Fetch and append unique WordPress authentication salts for improved security
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php

# -------------------------
# Permissions and ownership
# -------------------------

# Set Apache user as the owner of all WordPress files
chown -R www-data:www-data /var/www/html

# Set directory permissions to allow traversal and reading
find /var/www/html -type d -exec chmod 755 {} \;

# Set file permissions to allow reading but prevent execution
find /var/www/html -type f -exec chmod 644 {} \;

# -------------------------
# Completion
# -------------------------

# Log the completion time of the bootstrap process
echo "BOOTSTRAP FINISHED at $(date)"
