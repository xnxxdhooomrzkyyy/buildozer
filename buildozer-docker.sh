#!/bin/bash
set -e

echo "[*] Install Docker..."
wget -qO- https://get.docker.com/ | sh

echo "[*] Tambah user ke grup docker (biar bisa jalan tanpa sudo)..."
usermod -aG docker $USER

echo "[*] Tarik image buildozer resmi..."
docker pull kivy/buildozer

echo ""
echo "[*] Jalankan buildozer container!"
echo "Cara pakai:"
echo "  cd /path/ke/project"
echo "  ./buildozer_docker.sh run"
echo ""

if [ "$1" == "run" ]; then
    docker run -it --rm \
        -v $PWD:/home/user/hostcwd \
        kivy/buildozer \
        bash
fi
