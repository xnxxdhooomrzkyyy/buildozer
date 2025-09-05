#!/bin/bash
set -e

echo "=== Update & Upgrade Sistem ==="
sudo apt update && sudo apt upgrade -y

echo "=== Install Dependencies Dasar ==="
sudo apt install -y \
    python3-pip \
    python3-setuptools \
    python3-dev \
    build-essential \
    git \
    zip \
    unzip \
    zlib1g-dev \
    libncurses5-dev \
    libstdc++6 \
    libffi-dev \
    libssl-dev \
    libsqlite3-dev \
    libjpeg-dev \
    libfreetype6-dev \
    openjdk-11-jdk \
    curl

echo "=== Setting JAVA_HOME ke JDK 11 ==="
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which javac))))
echo "export JAVA_HOME=$JAVA_HOME_PATH" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

echo "=== Upgrade pip, install cython, wheel, virtualenv ==="
pip3 install --upgrade pip cython wheel virtualenv

echo "=== Install Kivy (opsional, untuk test di WSL2) ==="
pip3 install kivy

echo "=== Install Buildozer ==="
pip3 install buildozer

echo "=== Instalasi selesai ✅ ==="
echo "Sekarang coba jalankan:"
echo "  mkdir ~/MyApp && cd ~/MyApp"
echo "  buildozer init"
echo "  buildozer -v android debug"
