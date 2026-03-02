#!/bin/bash

# --- 1. CONFIGURATION ---
BASE_URL="https://rifqgames.online"
AUTOPLAY_URLS=("https://rifqgames.online/play.php")
WARMUP_SITES=("https://www.wikipedia.org" "https://www.detik.com" "https://www.kompas.com" "https://www.google.com/search?q=game+online+2026")
REFERRERS=("https://www.google.com/" "https://m.facebook.com/" "https://t.co/" "https://www.bing.com/")
DURATION_MIN=150
DURATION_MAX=300

# --- 2. KOORDINAT SNIPER (LOCKED @ 971,1) ---
CONSENT_X=1268
CONSENT_Y=708
PLAY_BUTTON_X=1354
PLAY_BUTTON_Y=550
CLOSE_AD_GAME_X=1116
CLOSE_AD_GAME_Y=773

# --- 3. DAFTAR USER AGENT ---
UA_LIST=(
    # --- ANDROID (Chrome & Edge) ---
    "Mozilla/5.0 (Linux; Android 14; SM-S928B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36"
    "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36"
    "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36"
    "Mozilla/5.0 (Linux; Android 14; SM-A546B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Mobile Safari/537.36 EdgA/120.0.0.0"

    # --- IOS (iPhone Safari & Chrome iOS) ---
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/116.0.5845.103 Mobile/15E148 Safari/604.1"
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1"

    # --- DESKTOP WINDOWS (Chrome, Firefox, Edge) ---
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Gecko/20100101 Firefox/127.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0"

    # --- DESKTOP MAC & LINUX ---
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0"

    # --- TABLET (iPad & Android Tab) ---
    "Mozilla/5.0 (iPad; CPU OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1"
    "Mozilla/5.0 (Linux; Android 13; SM-X906B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
)

# --- 4. ZERO-DAY HUMAN KERNEL FUNCTIONS ---

human_heartbeat_sleep() {
    local base=$1
    local jitter=$(echo "scale=4; $RANDOM/32767" | bc)
    local final=$(echo "scale=4; $base + $jitter" | bc)
    sleep $final
}

log_matrix() {
    echo -ne "\r\e[1;32m[PATRICK_V40.2]\e[0m \e[1;37m>>\e[0m \e[32m$1\e[0m"
}

hex_dump_sim() {
    for i in {1..8}; do
        echo -e "\e[32m0x$(printf '%04x' $RANDOM):$(printf '%02x %02x %02x %02x %02x %02x %02x %02x' $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM)\e[0m"
        sleep 0.03
    done
}

cyber_progress() {
    local duration=$1
    local message=$2
    echo -ne "\e[1;32m⚡ $message\e[0m ["
    for ((i=1; i<=30; i++)); do
        echo -ne "■"
        sleep $(echo "scale=4; ($duration/30) + (0.00$RANDOM/25)" | bc)
    done
    echo -e "] \e[1;32m100%\e[0m"
}

# GERAKAN MOUSE MELENGKUNG (ANTI-BOT)
human_move_curve() {
    local tx=$1 ty=$2
    local cur_pos=($(xdotool getmouselocation --shell | grep -E 'X|Y' | cut -d= -f2))
    local cx=${cur_pos[0]} cy=${cur_pos[1]}
    
    # Titik kontrol acak untuk kurva Bezier sederhana
    local mx=$(( (cx + tx) / 2 + RANDOM%80 - 40 ))
    local my=$(( (cy + ty) / 2 + RANDOM%80 - 40 ))
    
    xdotool mousemove --sync $mx $my
    human_heartbeat_sleep 0.1
    xdotool mousemove --sync $tx $ty
}

human_click() {
    local tx=$1 ty=$2
    # Jitter pixel acak +/- 6px
    local ox=$((tx + RANDOM%12 - 6))
    local oy=$((ty + RANDOM%12 - 6))
    
    human_move_curve $ox $oy
    human_heartbeat_sleep 0.2
    xdotool click 1
    log_matrix "CLICK_SENT: [$ox, $oy]"
}

# KETIK SEPERTI ORANG ASLI (JITTER PER HURUF)
human_type_stealth() {
    log_matrix "TYPING_SPOOF: $1"
    xdotool key ctrl+l; human_heartbeat_sleep 1.2
    for (( i=0; i<${#1}; i++ )); do
        xdotool type "${1:$i:1}"
        # Delay acak antar huruf (0.05s - 0.15s)
        sleep $(echo "scale=4; 0.05 + $RANDOM/250000" | bc)
    done
    human_heartbeat_sleep 0.5
    xdotool key Return
}

random_scroll_soft() {
    log_matrix "BEHAVIOR: SCROLLING..."
    xdotool click $((RANDOM%2 + 4)) # Acak scroll up/down
    human_heartbeat_sleep 0.4
}

# --- 5. MAIN EXECUTION ENGINE ---
RONDE=1
while true; do
    clear
    echo -e "\e[1;32m"
    echo "  ██████╗  █████╗ ████████╗██████╗ ██╗ ██████╗██╗  ██╗"
    echo "  ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██║██╔════╝██║ ██╔╝"
    echo "  ██████╔╝███████║   ██║   ██████╔╝██║██║     █████╔╝ "
    echo "  ██╔═══╝ ██╔══██║   ██║   ██╔══██╗██║██║     ██╔═██╗ "
    echo "  ██║     ██║  ██║   ██║   ██║  ██║██║╚██████╗██║  ██╗"
    echo "  ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "\e[0m"
    
    RANDOM_UA=${UA_LIST[$RANDOM % ${#UA_LIST[@]}]}
    RANDOM_CPU=$(( (RANDOM % 4) + 4 ))
    RANDOM_RAM=$(( (RANDOM % 8) + 4 ))
    AUTOPLAY_URL=${AUTOPLAY_URLS[$RANDOM % ${#AUTOPLAY_URLS[@]}]}
    
    W_JITTER=$((360 + RANDOM%15))
    H_JITTER=$((1200 + RANDOM%15))
    
    echo -e "\e[1;32m[+]\e[0m OPERATOR: PATRICK_V40.2 | SESSION #$RONDE"
    echo -e "\e[1;32m[+]\e[0m TARGET  : $AUTOPLAY_URL"
    echo -e "\e[32m------------------------------------------------------------\e[0m"
    
    hex_dump_sim
    pkill -f "chrome" 2>/dev/null
    TEMP_DIR=$(mktemp -d)
    
    # LAUNCHING SILENT GHOST
    google-chrome --new-window --incognito --no-sandbox --user-data-dir="$TEMP_DIR" \
      --user-agent="$RANDOM_UA" --window-size=$W_JITTER,$H_JITTER \
      --window-position=971,1 \
      --disable-blink-features=AutomationControlled \
      --blink-settings=deviceMemory=$RANDOM_RAM,hardwareConcurrency=$RANDOM_CPU \
      --disable-webrtc --no-first-run --mute-audio \
      --referrer="${REFERRERS[$RANDOM % ${#REFERRERS[@]}]}" "${WARMUP_SITES[$RANDOM % ${#WARMUP_SITES[@]}]}" > /dev/null 2>&1 &

    cyber_progress 10 "INITIALIZING_FINGERPRINT"
    
    human_type_stealth "$BASE_URL"
    human_heartbeat_sleep 12
    human_click $CONSENT_X $CONSENT_Y
    
    human_heartbeat_sleep 3
    human_type_stealth "$AUTOPLAY_URL"
    cyber_progress 15 "SPOOFING_USER_TRAFFIC"

    # Precision Clicks
    human_heartbeat_sleep 8
    for i in {1..3}; do random_scroll_soft; done
    human_click $PLAY_BUTTON_X $PLAY_BUTTON_Y
    
    # Watchdog Duration Loop
    END_TIME=$(( $(date +%s) + $((RANDOM % (DURATION_MAX - DURATION_MIN + 1) + DURATION_MIN)) ))
    while [ $(date +%s) -lt $END_TIME ]; do
        REMAINING=$(( END_TIME - $(date +%s) ))
        log_matrix "STATUS: ACTIVE | ENTROPY: 0x$(printf '%02x' $RANDOM) | TTL: ${REMAINING}s"
        
        # Micro-fidget: Gerakan mouse sangat kecil biar gak idle
        xdotool mousemove_relative -- $((RANDOM%2-1)) $((RANDOM%2-1))
        
        # Cek Close Ad (5% chance per loop)
        if [ $((RANDOM % 20)) -eq 7 ]; then 
            human_click $CLOSE_AD_GAME_X $CLOSE_AD_GAME_Y
        fi
        
        # Random Keys (Interaction simulation)
        case $((RANDOM % 5)) in
            0) xdotool key Right; sleep 0.1; xdotool key Left ;;
            1) xdotool key space ;;
        esac

        human_heartbeat_sleep $((RANDOM % 8 + 6))
    done

    log_matrix "WIPING_DNA_AND_SHUTTING_DOWN..."
    pkill -f "chrome"
    rm -rf "$TEMP_DIR" 2>/dev/null
    ((RONDE++))
    
    echo -e "\n\e[1;31m[!] COOLING_DOWN... (ANTI-SPAM DELAY)\e[0m"
    cyber_progress $((RANDOM % 30 + 30)) "IDLE_RECOVERY"
done
