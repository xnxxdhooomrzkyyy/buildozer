#!/bin/bash
set -e

echo "=== [1] Update sistem ==="
apt-get update
apt-get upgrade -y

echo "=== [2] Install dependency dasar ==="
apt-get install -y build-essential checkinstall \
    wget curl git libreadline-dev zlib1g-dev \
    libncurses5-dev libssl-dev libffi-dev \
    libsqlite3-dev libbz2-dev liblzma-dev \
    unzip zip openjdk-7-jdk lib32z1 lib32stdc++6

echo "=== [3] Download & compile Python 3.7.17 ==="
cd /usr/src
wget https://www.python.org/ftp/python/3.7.17/Python-3.7.17.tgz
tar -xvf Python-3.7.17.tgz
cd Python-3.7.17
./configure --enable-optimizations
make -j$(nproc)
make altinstall

echo "=== [4] Install pip terbaru untuk Python 3.7 ==="
wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py
python3.7 get-pip.py

echo "=== [5] Upgrade pip, setuptools, wheel ==="
pip3.7 install --upgrade pip setuptools wheel

echo "=== [6] Install Buildozer dari GitHub ==="
pip3.7 install git+https://github.com/kivy/buildozer.git

echo "=== [7] Selesai! Cek buildozer ==="
buildozer -v || echo "Buildozer berhasil di-install. Jalankan dengan: buildozer init"
