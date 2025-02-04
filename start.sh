#!/usr/bin/env bash
# starts everything
echo "Starting systemd headlessly..."
/sbin/init &  # Start systemd in the background
sleep 2  # Give systemd time to initialize
dbus-daemon --system &
sleep 2  # Give dbus time to initialize
systemctl daemon-reload
echo "installing dependencies"
 ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        echo "found amd64"; 
        wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb -O /tmp/os-agent.deb; 
    elif [ "$ARCH" = "arm64" ]; then \
        echo "found arm64";
        wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb -O /tmp/os-agent.deb; 
    else 
        echo "Unsupported architecture: $ARCH" && exit 1; 
    fi && 
    dpkg -i /tmp/os-agent.deb && rm -f /tmp/os-agent.deb
wget https://github.com/home-assistant/supervised-installer/releases/download/2.0.0/homeassistant-supervised.deb
DATA_SHARE=/homeassistant dpkg --force-confdef --force-confold -i homeassistant-supervised.deb