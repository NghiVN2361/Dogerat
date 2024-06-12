#!/bin/bash

# Variables
ROOT_PASSWORD="27272727"

# Set root password
echo "root:$ROOT_PASSWORD" | chpasswd

# Enable root login over SSH
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
systemctl restart sshd

# Ensure SSH service is enabled on boot
systemctl enable sshd

# Allow SSH through the firewall (if applicable)
if command -v ufw &> /dev/null; then
    ufw allow ssh
    ufw reload
elif command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --reload
elif command -v iptables &> /dev/null; then
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables-save > /etc/iptables/rules.v4
fi

# Confirm SSH service status
systemctl status sshd

