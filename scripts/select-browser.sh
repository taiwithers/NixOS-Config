#!/usr/env/bin bash
profile=$(echo -e "Personal\nStudent" | rofi -dmenu -prompt "Select profile" -l 2)
firefox -P "$profile" "$1"

