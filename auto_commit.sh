#!/bin/bash

cd /home//push-flow || exit

commits_file="/home/NAZIMA KYLYCHBEKOVA/push-flow/commits_today.txt"
last_clean_file="/home/NAZIMA KYLYCHBEKOVA/push-flow/last_clean_date.txt"
last_push_file="/home/NAZIMA KYLYCHBEKOVA/push-flow/last_push_time.txt"
log_file="/home/NAZIMA KYLYCHBEKOVA/push-flow/auto_update.txt"

current_date=$(date +%Y-%m-%d)

if [ ! -f "$last_clean_file" ] || [ "$current_date" != "$(cat "$last_clean_file")" ]; then
    > "$log_file"

    echo "$current_date" > "$last_clean_file"

    commits_today=$((65 + RANDOM % 16))
    echo $commits_today > "$commits_file"

    echo "0" > "$last_push_file"
fi

commits_left=$(cat "$commits_file")

if [ "$commits_left" -gt 0 ]; then
    last_push=$(cat "$last_push_file")
    current_time=$(date +%s)

    day_start=$(date -d "$(date +%Y-%m-%d) 00:00:00" +%s)
    day_end=$(date -d "$(date +%Y-%m-%d) 23:59:59" +%s)
    total_seconds=$((day_end - day_start))
    interval=$((total_seconds / $(cat "$commits_file")))

    if [ $((current_time - last_push)) -ge "$interval" ]; then
        echo "$(date) - Auto commit executed" >> "$log_file"

        git add .
        git commit -m "Auto commit - Remaining: $commits_left on $(date)"
        git push origin main

        echo $((commits_left - 1)) > "$commits_file"
        echo "$current_time" > "$last_push_file"
    fi
fi
