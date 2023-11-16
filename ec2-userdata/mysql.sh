#!/bin/bash

DATABASE_PASS='admin123'

# Update package information and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install necessary packages
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt install -y git zip unzip mariadb-server

# Start and enable mariadb-server
sudo systemctl start mysql
sudo systemctl enable mysql

# Clone the repository
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Restore the dump file for the application
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$DATABASE_PASS';"
sudo mysql -u root -p"$DATABASE_PASS" -e "DROP USER IF EXISTS ''@'localhost';"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mariadb-server
sudo systemctl restart mysql

# Start firewall and allow mariadb to access from port no. 3306
sudo ufw allow 3306
sudo systemctl restart mysql
