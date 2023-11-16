#!/bin/bash

# Install necessary packages
sudo apt update
sudo apt install -y memcached

# Start and enable memcached
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# Update memcached configuration to listen on all interfaces
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/memcached.conf

# Restart memcached
sudo systemctl restart memcached

# Configure firewall to allow memcached ports
sudo ufw allow 11211/tcp
sudo ufw allow 11111/udp
sudo systemctl restart ufw

# Start memcached with specific options
sudo memcached -p 11211 -U 11111 -u memcached -d
