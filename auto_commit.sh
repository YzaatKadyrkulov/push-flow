#!/bin/bash

# TODO Путь к проекту на Windows через Git Bash
project_dir="/c/Users/NAZIMA KYLYCHBEKOVA/PycharmProjects/push-flow"
cd "$project_dir" || exit

commits_file="$project_dir/commits_today.txt"
last_clean_file="$project_dir/last_clean_date.txt"
last_push_file="$project_dir/last_push_time.txt"
log_file="$project_dir/auto_update.txt"

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