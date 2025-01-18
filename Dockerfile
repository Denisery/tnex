# Use an official lightweight Linux base image
FROM ubuntu:20.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install OpenSSH Server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Create a user for SSH access
RUN useradd -m -s /bin/bash vpnuser && \
    echo "vpnuser:password123" | chpasswd && \
    mkdir -p /home/vpnuser/.ssh && \
    chmod 700 /home/vpnuser/.ssh

# Allow SSH tunneling by modifying the sshd_config
RUN sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#GatewayPorts no/GatewayPorts yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]
