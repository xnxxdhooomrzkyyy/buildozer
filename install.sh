#!/bin/bash
# Buildozer full installer for Kali Linux 2025.2
# Includes: dependencies, pipx + buildozer, Android SDK & NDK (with fallback)
set -e

echo "==============================================="
echo "   Buildozer + Android SDK/NDK Installer        "
echo "   For Kali Linux 2025.2                        "
echo "==============================================="

echo "[*] Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "[*] Installing core dependencies..."
sudo apt install -y build-essential git python3 python3-pip python3-venv \
    python3-setuptools python3-dev libffi-dev libssl-dev \
    libsqlite3-dev zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libreadline-dev libbz2-dev unzip curl wget pipx

# --- JDK Handling ---
echo "[*] Checking for available JDK..."
JAVA_HOME_PATH=""

if sudo apt install -y openjdk-21-jdk; then
    JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-amd64"
elif sudo apt install -y openjdk-17-jdk; then
    JAVA_HOME_PATH="/usr/lib/jvm/java-17-openjdk-amd64"
elif sudo apt install -y openjdk-11-jdk; then
    JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
else
    echo "[!] No OpenJDK package found in repo. Please install manually!"
    exit 1
fi

echo "[*] Setting JAVA_HOME..."
if ! grep -q "JAVA_HOME" ~/.bashrc; then
    echo "export JAVA_HOME=$JAVA_HOME_PATH" >> ~/.bashrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
fi
export JAVA_HOME=$JAVA_HOME_PATH
export PATH=$JAVA_HOME/bin:$PATH

# --- pipx setup ---
echo "[*] Ensuring pipx is available in PATH..."
if ! grep -q ".local/bin" ~/.bashrc; then
    echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
fi
export PATH=$PATH:~/.local/bin

# --- Buildozer install ---
echo "[*] Installing/Upgrading buildozer with pipx..."
pipx install buildozer || pipx upgrade buildozer

# --- Android SDK/NDK setup ---
ANDROID_PLATFORM=$HOME/.buildozer/android/platform
ANDROID_SDK_ROOT=$ANDROID_PLATFORM/android-sdk
ANDROID_NDK_ROOT=""

mkdir -p $ANDROID_PLATFORM

# SDK
if [ ! -d "$ANDROID_SDK_ROOT" ]; then
    echo "[*] Downloading Android SDK (cmdline-tools)..."
    cd $ANDROID_PLATFORM
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O sdk-tools.zip
    unzip -q sdk-tools.zip -d android-sdk
    rm sdk-tools.zip
fi

# NDK: try r26b, fallback to r25c
cd $ANDROID_PLATFORM
if [ ! -d "$ANDROID_PLATFORM/android-ndk-r26b" ]; then
    echo "[*] Trying Android NDK r26b..."
    if wget -q https://dl.google.com/android/repository/android-ndk-r26b-linux.zip -O ndk.zip; then
        unzip -q ndk.zip
        ANDROID_NDK_ROOT=$ANDROID_PLATFORM/android-ndk-r26b
        rm ndk.zip
    else
        echo "[!] NDK r26b not available, falling back to r25c..."
        wget -q https://dl.google.com/android/repository/android-ndk-r25c-linux.zip -O ndk.zip
        unzip -q ndk.zip
        ANDROID_NDK_ROOT=$ANDROID_PLATFORM/android-ndk-r25c
        rm ndk.zip
    fi
else
    ANDROID_NDK_ROOT=$ANDROID_PLATFORM/android-ndk-r26b
fi

# --- Android SDK manager setup ---
echo "[*] Installing Android SDK platforms & build-tools..."
yes | $ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
    "platforms;android-33" "platform-tools" "build-tools;33.0.2"

# --- Environment vars ---
if ! grep -q "ANDROID_SDK_ROOT" ~/.bashrc; then
    echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> ~/.bashrc
    echo "export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT" >> ~/.bashrc
    echo 'export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH' >> ~/.bashrc
fi
export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH

echo "==============================================="
echo "[✔] Installation complete!"
echo "-> Run: source ~/.bashrc"
echo "-> Test: buildozer --version"
echo "-> SDK:  $ANDROID_SDK_ROOT"
echo "-> NDK:  $ANDROID_NDK_ROOT"
echo "==============================================="
