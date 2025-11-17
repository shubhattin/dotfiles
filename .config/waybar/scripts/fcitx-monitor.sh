#!/bin/bash

# Get current input method from fcitx5
get_current_im() {
    # Try fcitx5-remote first
    if command -v fcitx5-remote &> /dev/null; then
        IM=$(fcitx5-remote -n 2>/dev/null)
    elif command -v fcitx-remote &> /dev/null; then
        IM=$(fcitx-remote -n 2>/dev/null)
    else
        echo "EN"
        return
    fi
    
    # Extract language code from input method name
    case "$IM" in
        *keyboard-us*|*keyboard-en*|*en_US*)
            echo "EN"
            ;;
        *pinyin*|*chinese*|*zh*)
            echo "ZH"
            ;;
        *hindi*|*devanagari*|*hi*)
            echo "HI"
            ;;
        *japanese*|*ja*|*mozc*)
            echo "JA"
            ;;
        *korean*|*ko*|*hangul*)
            echo "KO"
            ;;
        *arabic*|*ar*)
            echo "AR"
            ;;
        *russian*|*ru*)
            echo "RU"
            ;;
        *spanish*|*es*)
            echo "ES"
            ;;
        *french*|*fr*)
            echo "FR"
            ;;
        *german*|*de*)
            echo "DE"
            ;;
        *)
            # Try to extract first 2 chars or show generic
            if [[ ${#IM} -ge 2 ]]; then
                echo "${IM:0:2}" | tr '[:lower:]' '[:upper:]'
            else
                echo "EN"
            fi
            ;;
    esac
}

# Output current IM and monitor for changes
get_current_im

# Monitor for changes (dbus-monitor for fcitx signals)
if command -v dbus-monitor &> /dev/null; then
    dbus-monitor "path='/controller',interface='org.fcitx.Fcitx.Controller1'" 2>/dev/null |
    while read -r line; do
        if [[ $line == *"CurrentInputMethod"* ]] || [[ $line == *"member=CommitString"* ]]; then
            sleep 0.1
            get_current_im
        fi
    done
else
    # Fallback: poll every 2 seconds
    while true; do
        sleep 2
        get_current_im
    done
fi

