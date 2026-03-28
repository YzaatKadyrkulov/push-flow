C:\Program Files\Git\bin\bash.exe

# Windows Git Bash compatible script
project_dir="/c/Users/NAZIMA KYLYCHBEKOVA/PycharmProjects/push-flow"
cd "$project_dir" || exit

commits_file="$project_dir/commits_today.txt"
last_clean_file="$project_dir/last_clean_date.txt"
last_push_file="$project_dir/last_push_time.txt"
log_file="$project_dir/auto_update.txt"

current_date=$(date +%Y-%m-%d)

# Reset daily counters if it's a new day
if [ ! -f "$last_clean_file" ] || [ "$current_date" != "$(cat "$last_clean_file")" ]; then
    > "$log_file"
    echo "$current_date" > "$last_clean_file"

    commits_today=$((65 + RANDOM % 16))
    echo "$commits_today" > "$commits_file"
    echo "0" > "$last_push_file"
fi

commits_left=$(cat "$commits_file")

if [ "$commits_left" -gt 0 ]; then
    last_push=$(cat "$last_push_file")
    current_time=$(date +%s)

    # Windows Git Bash compatible interval calculation (no date -d)
    hour=$(date +%H)
    min=$(date +%M)
    sec=$(date +%S)
    total_seconds=86400
    original_commits=$(cat "$commits_file")

    if [ "$original_commits" -le 0 ]; then
        original_commits=65
    fi

    interval=$((total_seconds / original_commits))

    if [ $((current_time - last_push)) -ge "$interval" ]; then
        echo "$(date) - Auto commit executed" >> "$log_file"

        # git is available directly in Git Bash without full path
        git add .
        git commit -m "Auto commit - Remaining: $commits_left on $(date)"
        git push origin main >> "$log_file" 2>&1

        echo $((commits_left - 1)) > "$commits_file"
        echo "$current_time" > "$last_push_file"
    fi
fi