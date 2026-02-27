#!/bin/bash

echo "[1] Uninstall Chrome stable..."
sudo apt remove --purge google-chrome-stable -y

echo "[2] Download Chrome 127..."
wget https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_127.0.6533.119-1_amd64.deb -O chrome127.deb

echo "[3] Install Chrome 127..."
sudo dpkg -i chrome127.deb
sudo apt -f install -y

echo "[4] Prevent Chrome from auto-updating..."
sudo bash -c 'cat > /etc/apt/preferences.d/no-upgrade-chrome <<EOF
Package: google-chrome-stable
Pin: version 127.*
Pin-Priority: 1001
EOF'

echo "[5] Done! Current Chrome version:"
google-chrome-stable --version
