#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y ca-certificates curl gnupg lsb-release software-properties-common

if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."

    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "✅ Docker already installed"
fi

if ! docker compose version &> /dev/null; then
    apt-get install -y docker-compose-plugin
else
    echo "✅ Docker Compose plugin already installed"
fi

PYTHON_VERSION=$(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")

if dpkg --compare-versions "$PYTHON_VERSION" ge "3.9"; then
    echo "✅ Python $PYTHON_VERSION is 3.9 or newer"
else
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get install -y python3.9 python3.9-distutils
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
fi

if ! command -v pip3 &> /dev/null; then
    apt-get install -y python3-pip
else
    echo "✅ pip is already installed"
fi

if ! python3 -m django --version &> /dev/null; then
    pip3 install --break-system-packages django
else
    echo "✅ Django already installed"
fi
