#!/bin/bash
# Downgrade Google Chrome to version 130 and disable auto-updates on Ubuntu
# Made by Patrick Ivanuell

set -e

echo "=== Menghapus versi Chrome yang ada... ==="
sudo apt remove -y google-chrome-stable || true

echo "=== Mengunduh Google Chrome versi 130.0.6723.91... ==="
wget -q https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_130.0.6723.91-1_amd64.deb -O /tmp/google-chrome-stable_130.deb

echo "=== Menginstal versi 130... ==="
sudo dpkg -i /tmp/google-chrome-stable_130.deb || sudo apt -f install -y

echo "=== Membuat preferensi untuk mengunci versi 130... ==="
sudo mkdir -p /etc/apt/preferences.d
sudo tee /etc/apt/preferences.d/google-chrome > /dev/null <<EOF
Package: google-chrome-stable
Pin: version 130.*
Pin-Priority: 1001
EOF

echo "=== Menonaktifkan repositori update otomatis Chrome... ==="
if [ -f /etc/apt/sources.list.d/google-chrome.list ]; then
  sudo mv /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google-chrome.list.disabled
fi

echo "=== Membersihkan cache... ==="
sudo apt clean

echo "=== Mengecek versi Chrome saat ini... ==="
google-chrome --version || echo "Selesai. Silakan cek Chrome secara manual."

echo "✅ Downgrade dan penguncian versi selesai!"
