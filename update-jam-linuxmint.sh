#!/bin/bash
# reset-jam.sh
# Skrip reset jam otomatis di Linux Mint

# Default manual time (kalau tidak ada internet)
DEFAULT_TIME="2025-01-01 00:00:00"

echo "[*] Cek koneksi internet..."
ping -c1 8.8.8.8 &>/dev/null

if [ $? -eq 0 ]; then
    echo "[*] Internet tersedia, sinkronisasi dengan NTP..."
    
    # Pastikan ntpdate ada
    if ! command -v ntpdate &>/dev/null
    then
        echo "[!] ntpdate belum terinstall, install dulu:"
        echo "    sudo apt install ntpdate -y"
        exit 1
    fi

    sudo service ntp stop 2>/dev/null
    sudo ntpdate pool.ntp.org
    sudo service ntp start 2>/dev/null

else
    echo "[!] Internet tidak tersedia, set jam manual ke $DEFAULT_TIME"
    sudo date -s "$DEFAULT_TIME"
fi

echo "[*] Waktu sekarang:"
date
