#!/usr/bin/env bash
# Starts everything
set -e
echo "Starting systemd headlessly..."
exec /usr/bin/tini -s -- /sbin/init
sleep 2  # Give systemd time to initialize

echo "Starting D-Bus daemon..."
dbus-daemon --system &
sleep 2  # Give dbus time to initialize

systemctl daemon-reload

echo "Installing dependencies..."
ARCH=$(dpkg --print-architecture)

if [ "$ARCH" = "amd64" ]; then
    echo "Found amd64"
    wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb -O /tmp/os-agent.deb
elif [ "$ARCH" = "arm64" ]; then
    echo "Found arm64"
    wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb -O /tmp/os-agent.deb
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

dpkg -i /tmp/os-agent.deb && rm -f /tmp/os-agent.deb

wget https://github.com/home-assistant/supervised-installer/releases/download/2.0.0/homeassistant-supervised.deb
DATA_SHARE=/homeassistant dpkg --force-confdef --force-confold -i homeassistant-supervised.deb

# Ensure tini remains PID 1 and systemd runs correctly
exec /usr/bin/tini -- /sbin/init
