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
    tini \
    && rm -rf /var/lib/apt/lists/*

# Install Docker via get.docker.com
RUN curl -fsSL https://get.docker.com | bash

# Copy start script
COPY start.sh /usr/bin/start
RUN chmod +x /usr/bin/start

# Ensure systemd can start services
RUN echo exit 0 > /usr/sbin/policy-rc.d

# Volumes for systemd and Home Assistant
VOLUME ["/sys/fs/cgroup", "/homeassistant"]
# Expose Home Assistant default port
EXPOSE 8123

# ENTRYPOINT runs tini to start systemd as PID 1
ENTRYPOINT ["/usr/bin/tini", "--", "/lib/systemd/systemd", "--system", "--unit=multi-user.target"]

# CMD runs the startup script
CMD ["/usr/bin/start"]