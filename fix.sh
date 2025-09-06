#!/bin/bash
# Fix SSL connection issues on old Kali Linux (1.1)

echo "[*] Memperbaiki SSL issue di Kali Linux 1.1..."

# 1. Sinkronisasi waktu
echo "[*] Sinkronisasi waktu sistem..."
sudo apt-get update -y
sudo apt-get install -y ntpdate
sudo ntpdate pool.ntp.org

# 2. Install ulang CA certificates
echo "[*] Install / reinstall CA certificates..."
sudo apt-get install --reinstall -y ca-certificates
sudo update-ca-certificates

# 3. Update OpenSSL, wget, curl
echo "[*] Update OpenSSL, wget, dan curl..."
sudo apt-get install -y openssl wget curl

# 4. Tes koneksi HTTPS
echo "[*] Test koneksi ke https://google.com"
curl -Iv https://google.com || wget --no-check-certificate https://google.com

echo "[*] Selesai! Coba jalankan lagi perintah yang sebelumnya error."
