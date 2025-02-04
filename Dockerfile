# Dockerfile for Home Assistant with Systemd
FROM debian:latest

# Enable non-interactive APT mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    systemd \
    curl \
    gnupg \
    lsb-release \
    ca-certificates \
    libgpgme11 \
    apparmor \
    apt-transport-https \
    bluez \
    cifs-utils \
    dbus \
    jq \
    libglib2.0-bin \
    network-manager \
    nfs-common \
    systemd-journal-remote \
    systemd-resolved \
    systemd-sysv \
    udisks2 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Docker via get.docker.com
RUN curl -fsSL https://get.docker.com | bash
# Copy start script
COPY start.sh /usr/bin/start
RUN chmod +x /usr/bin/start

# Volumes for systemd and home assistant
VOLUME ["/sys/fs/cgroup", "/homeassistant"]

# Ensure systemd can start services
RUN echo exit 0 > /usr/sbin/policy-rc.d

# Expose Home Assistant default port
EXPOSE 8123

# Entrypoint to start script
ENTRYPOINT /usr/bin/start