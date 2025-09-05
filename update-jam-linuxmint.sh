#!/bin/bash
# reset-time.sh
# Skrip untuk reset/sinkronisasi jam di Linux Mint

echo "[*] Sinkronisasi waktu dengan server NTP..."

# Pastikan ntpdate ada
if ! command -v ntpdate &> /dev/null
then
    echo "ntpdate belum terinstall, install dulu dengan:"
    echo "  sudo apt install ntpdate -y"
    exit 1
fi

# Sync ke server ntp pool
sudo service ntp stop 2>/dev/null
sudo ntpdate pool.ntp.org
sudo service ntp start 2>/dev/null

echo "[*] Waktu setelah sinkronisasi:"
date
