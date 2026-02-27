#!/bin/bash

# --- KONFIGURASI TARGET ---
TARGET_URL="https://easlygame.com/autoplay"
DURATION_MIN=35
DURATION_MAX=65

# --- KOORDINAT (Sesuaikan dengan resolusi RDP kamu) ---
# 1. Koordinat Tombol Consent (Biasanya biru)
GDPR_X=629; GDPR_Y=683

# 2. Koordinat Tanda Silang (X) Pop-up Google (Vignette)
CLOSE_AD_X=888; CLOSE_AD_Y=184

# 3. Koordinat Iklan Banner di Halaman (Bawah/Samping Game)
# Ganti angka ini dengan hasil 'xdotool getmouselocation' kamu
PAGE_AD_X=500; PAGE_AD_Y=750 

# 4. Koordinat Tombol Play Game
PLAY_X=706; PLAY_Y=665

# --- FUNGSI HUMAN SENSE ---
human_click_jitter() {
    local target_x=$1
    local target_y=$2
    # Geser sedikit agar tidak terdeteksi bot statis (+/- 5px)
    local final_x=$((target_x + (RANDOM % 11 - 5)))
    local final_y=$((target_y + (RANDOM % 11 - 5)))
    
    xdotool mousemove $final_x $final_y
    sleep 0.3
    xdotool mousedown 1
    sleep 0.1
    xdotool mouseup 1
}

# --- MAIN ENGINE LOOP ---
while true; do
    clear
    echo "[Ronde] Dimulai pada: $(date +%H:%M:%S)"
    TEMP_DIR=$(mktemp -d)

    # 1. JALANKAN CHROME (Pembersihan Pop-up Sistem)
    google-chrome --incognito --new-window --no-sandbox \
      --user-data-dir="$TEMP_DIR" \
      --no-first-run --no-default-browser-check \
      --disable-infobars --disable-notifications \
      --disable-session-crashed-bubble --password-store=basic \
      "$TARGET_URL" &

    sleep 18 # Jeda loading agar iklan & script web muncul semua

    # 2. STEP 1: BYPASS CONSENT
    echo "[Action] Klik Consent GDPR..."
    human_click_jitter $GDPR_X $GDPR_Y
    sleep 3

    # 3. STEP 2: KLIK IKLAN HALAMAN (ADS REVENUE)
    # Bot klik iklan di halaman, lalu tutup tab yang baru terbuka
    echo "[Action] Mengklik Iklan Banner..."
    human_click_jitter $PAGE_AD_X $PAGE_AD_Y
    sleep 2
    xdotool key ctrl+w # Tutup tab iklan dan kembali ke tab game
    echo "[Status] Kembali ke tab utama."
    sleep 2

    # 4. STEP 3: TUTUP POP-UP X IKLAN (JIKA ADA)
    echo "[Action] Mencoba tutup pop-up iklan (X)..."
    human_click_jitter $CLOSE_AD_X $CLOSE_AD_Y
    sleep 2

    # 5. STEP 4: KLIK PLAY GAME
    echo "[Action] Klik tombol PLAY!"
    human_click_jitter $PLAY_X $PLAY_Y
    sleep 3

    # 6. SESI INTERAKSI (PRILAKU MANUSIA)
    SESSION_TIME=$(( ( RANDOM % (DURATION_MAX - DURATION_MIN + 1) ) + DURATION_MIN ))
    END_TIME=$(( $(date +%s) + SESSION_TIME ))
    
    echo "[Session] Menjalankan interaksi selama $SESSION_TIME detik..."
    while [ $(date +%s) -lt $END_TIME ]; do
        case $((RANDOM % 4)) in
            0) xdotool click 5; sleep 0.2; xdotool click 4 ;; # Scroll halus
            1) xdotool key space ;; # Tombol aksi game
            2) xdotool key Down; sleep 0.5; xdotool key Up ;; # Gerak karakter
            3) # Gerak mouse random (Idle behavior)
               xdotool mousemove $(( (RANDOM % 200) + 400 )) $(( (RANDOM % 200) + 400 )) ;;
        esac
        # Jeda antar aksi agar tidak terlalu cepat
        sleep $(( (RANDOM % 6) + 4 ))
    done

    # 7. CLEANUP TOTAL (Sesuai Permintaan Patrick)
    echo "[Cleanup] Membersihkan Chrome & System..."
    pkill --oldest chrome
    pkill --oldest chrome
    pkill --oldest chrome
    pkill -f "chrome"
    
    rm -rf "$TEMP_DIR"
    sudo apt-get autoclean -y
    
    sleep 2
    clear
    echo "[Clean] Sistem Bersih. Ronde Selesai."
    /usr/games/sl -l # Hiburan kereta lewat
    
    JEDA=$(( (RANDOM % 15) + 5 ))
    echo "[Wait] Menunggu $JEDA detik sebelum ronde berikutnya..."
    sleep $JEDA
done
