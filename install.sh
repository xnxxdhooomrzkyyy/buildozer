#!/bin/bash
# Setup otomatis Buildozer di Linux Mint + Android SDK/NDK
# Tested on Mint 20/21 - Python 3.10+

set -e

echo "🔄 Update sistem..."
sudo apt update && sudo apt upgrade -y

echo "📦 Install dependency dasar..."
sudo apt install -y \
    git \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    python3-venv \
    python3-distutils \
    openjdk-17-jdk \
    unzip \
    zip \
    zlib1g-dev \
    libncurses5 \
    libncurses5-dev \
    libtinfo5 \
    libffi-dev \
    libssl-dev \
    libsqlite3-dev \
    libjpeg-dev \
    libpng-dev \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    pkg-config \
    autoconf \
    automake \
    cmake \
    build-essential \
    adb \
    curl

echo "✅ Dependency selesai diinstall."

# Setup virtualenv
echo "📂 Buat virtual environment untuk Buildozer..."
python3 -m venv ~/buildozer-venv
source ~/buildozer-venv/bin/activate

echo "⬆️ Upgrade pip dan install Buildozer + python-for-android..."
pip install --upgrade pip cython virtualenv
pip install buildozer python-for-android

# Android SDK & NDK setup
ANDROID_DIR=$HOME/Android
SDK_DIR=$ANDROID_DIR/Sdk
CMDLINE_DIR=$SDK_DIR/cmdline-tools

echo "📥 Download Android cmdline-tools..."
mkdir -p $CMDLINE_DIR
cd $ANDROID_DIR
curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip -q commandlinetools.zip -d $CMDLINE_DIR
mv $CMDLINE_DIR/cmdline-tools $CMDLINE_DIR/latest
rm commandlinetools.zip

echo "⚙️ Set environment variable..."
echo "export ANDROID_HOME=$SDK_DIR" >> ~/.bashrc
echo "export PATH=\$PATH:$SDK_DIR/emulator" >> ~/.bashrc
echo "export PATH=\$PATH:$SDK_DIR/platform-tools" >> ~/.bashrc
echo "export PATH=\$PATH:$CMDLINE_DIR/latest/bin" >> ~/.bashrc
source ~/.bashrc

echo "📥 Install SDK & NDK via sdkmanager..."
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-31" "build-tools;33.0.2" "ndk;23.1.7779620"

echo "🎉 Setup Buildozer + Android SDK/NDK selesai!"
echo ""
echo "👉 Jalankan perintah berikut sebelum pakai buildozer:"
echo "    source ~/buildozer-venv/bin/activate"
echo ""
echo "👉 Inisialisasi project baru:"
echo "    buildozer init"
echo ""
echo "👉 Build APK:"
echo "    buildozer -v android debug"
