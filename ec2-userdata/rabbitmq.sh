#!/bin/bash

# Install necessary packages
sudo apt update
sudo apt install -y wget

# Download and install RabbitMQ signing key
wget -O - "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq-archive-keyring.gpg

# Set up RabbitMQ APT repository
echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list > /dev/null

# Update package information
sudo apt update

# Install RabbitMQ server
sudo apt install -y rabbitmq-server

# Enable and start RabbitMQ service
sudo systemctl enable --now rabbitmq-server

# Configure firewall to allow RabbitMQ port (5672)
sudo ufw allow 5672/tcp
sudo systemctl restart ufw

# Check RabbitMQ service status
sudo systemctl status rabbitmq-server

# Configure RabbitMQ to allow remote connections
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Add a test user to RabbitMQ
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ service
sudo systemctl restart rabbitmq-server
