#!/bin/bash

# --- daftarurl---
TARGET_URLS=(
    "https://gendisgames.online/space-io"
    "https://gendisgames.online/edge-of-survival"
    "https://gendisgames.online/splashy-sub"
    "https://gendisgames.online/bridge-race-3d"
    "https://gendisgames.online/my-supermarket-simulator-3d"
    "https://gendisgames.online/drag-n-drop-games-color-match"
    "https://gendisgames.online/golf-orbit",
    "https://gendisgames.online/color-sort-impostor-edition",
    "https://gendisgames.online/crazy-table-tennis",
    "https://gendisgames.online/merge-monster-fight",
    "https://gendisgames.online/funny-crazy-watermelon",
    "https://gendisgames.online/italian-brainrot-quiz-mdash-meme-mastery",
    "https://gendisgames.online/breakfast-cooking-game",
)

WIDTH=1280
HEIGHT=720
BROWSER="google-chrome-stable"

while true; do
    URL=${TARGET_URLS[RANDOM % ${#TARGET_URLS[@]}]}
    TEMP_DIR=$(mktemp -d)
    
    echo "[System] Memulai ronde: $URL"

    # 1. Jalankan Chrome dengan Fix WebGL Swiftshader
    # Mengatasi 'Software Update Needed' agar game muncul sempurna
    $BROWSER --incognito --no-sandbox \
    --app="$URL" \
    --window-size=$WIDTH,$HEIGHT --window-position=0,0 \
    --use-gl=angle --use-angle=swiftshader \
    --ignore-gpu-blocklist --no-first-run --test-type \
    --user-data-dir="$TEMP_DIR" &
    
    sleep 20 # Waktu tunggu loading agar tombol Play muncul

    # 2. scanning
    WID=$(xdotool search --onlyvisible --class "google-chrome" | head -1)
    if [ -n "$WID" ]; then
        xdotool windowactivate $WID
        
        echo "[Visual] Mencari bentuk tombol Play..."
        scrot /tmp/play_scan.png

        # Deteksi kepadatan objek di tengah layar
        COORDS=$(convert /tmp/play_scan.png -gravity center -crop 500x400+0+0 \
                 -threshold 50% -format "%[fx:w*mean] %[fx:h*mean]" info: | awk '{print int($1)" "int($2)}')

        # Jika ada bentuk terdeteksi eksekusi (To The Point)
        echo "[Visual] Memulai Smart Z-Scanning di area tombol..."
        # Area diperluas (500x400) untuk mencakup game baru seperti Drag-n-Drop
        for y in {280..520..40}; do
            for x in {500..780..50}; do
                xdotool mousemove $x $y click 1
                sleep 0.05
            done
        done
    fi

    echo "[Session] Menunggu"
    sleep 45

    # 3. humaninteractive
    END_SESSION=$(( $(date +%s) + 60 ))
    while [ $(date +%s) -lt $END_SESSION ]; do
        
        # Humanized Movement
        TARGET_X=$(( (RANDOM % 800) + 240 ))
        TARGET_Y=$(( (RANDOM % 400) + 160 ))
        xdotool mousemove --sync $TARGET_X $TARGET_Y click 1
        
        # input keyboard aktif
        KEYS=("space" "Up" "Down" "Left" "Right" "w" "a" "s" "d")
        xdotool key ${KEYS[$RANDOM % 9]}

        # scroll acak
        if [ $((RANDOM % 5)) -eq 0 ]; then
            xdotool click 4 sleep 0.2 xdotool click 5
        fi

        sleep $(( (RANDOM % 3) + 2 ))
    done

# 5. COOLDOWN
    echo "[Cleanup] Ronde selesai, mendinginkan CPU VPS..."
    pkill -f "chrome"
    rm -rf "$TEMP_DIR"

    
    termdown 300 

    pkill --oldest chrome
    apt-get autoclean
    clear

   
    termdown 3
    /usr/games/sl -l
    
   #acak timing
    termdown $(( (RANDOM % 60) + 20 ))
done
