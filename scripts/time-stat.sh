#!/usr/bin/env bash

# --- Current timestamp ---
now=$(date +%s)

# --- Friendly header ---
current_line=$(date +"It's %A, %B %d, %Y — %I:%M %p")

# --- Determine week boundaries (Saturday 00:00 → Friday 23:59:59) ---
dow=$(date +%u)                     # 1=Mon ... 5=Fri ... 7=Sun
days_to_fri=$(( (5 - dow + 7) % 7 ))

end_week=$(date -d "+${days_to_fri} days 23:59:59" +%s)
start_week=$((end_week - 6 * 86400 + 1))

# --- Other boundaries ---
end_today=$(date -d 'tomorrow 00:00' +%s)
end_month=$(date -d "$(date +%Y-%m-01) +1 month -1 second" +%s)
end_year=$(date -d "$(date +%Y)-12-31 23:59:59" +%s)

start_today=$(date -d 'today 00:00' +%s)
start_month=$(date -d "$(date +%Y-%m-01)" +%s)
start_year=$(date -d "$(date +%Y)-01-01" +%s)

# --- Total durations ---
total_today=86400
total_week=$((end_week - start_week + 1))
total_month=$((end_month - start_month + 1))
total_year=$((end_year - start_year + 1))

# --- Compute values ---
rem_today=$((end_today - now))
rem_week=$((end_week - now))
rem_month=$((end_month - now))
rem_year=$((end_year - now))

elapsed_today=$((now - start_today))
elapsed_week=$((now - start_week))
elapsed_month=$((now - start_month))
elapsed_year=$((now - start_year))

# --- Format time with context-aware units ---
format_time() {
  local period="$1" s=$(( $2 ))
  (( s <= 0 )) && { echo "–"; return; }
  local d=$((s / 86400)) h=$(( (s % 86400) / 3600 ))

  case "$period" in
    today)
      if (( h == 0 )); then
        echo "<1h"
      else
        echo "${h}h"
      fi ;;
    week|month)
      if (( d == 0 )); then
        echo "<1d"
      else
        echo "${d}d"
      fi ;;
    year)
      local months=$(( d / 30 ))
      if (( months == 0 )); then
        echo "<1mo"
      else
        echo "${months}mo"
      fi ;;
  esac
}

# --- Render clean progress bar ---
render_bar() {
  local elapsed=$1 total=$2
  (( total <= 0 || elapsed <= 0 )) && { echo "░░░░░░░░░░  0%"; return; }
  local pct=$(( elapsed * 100 / total ))
  (( pct > 100 )) && pct=100
  local filled=$(( pct / 10 ))
  local bar=$(printf "%0.s█" $(seq 1 $filled))$(printf "%0.s░" $(seq 1 $((10 - filled))))
  printf "%s %3d%%" "$bar" "$pct"
}

# --- Output: minimal, clean, professional ---
echo
echo "$current_line"
echo
printf "%-6s %-8s %s\n" "today"  "$(format_time today  $rem_today)"   "$(render_bar $elapsed_today $total_today)"
printf "%-6s %-8s %s\n" "week"   "$(format_time week   $rem_week)"    "$(render_bar $elapsed_week $total_week)"
printf "%-6s %-8s %s\n" "month"  "$(format_time month  $rem_month)"   "$(render_bar $elapsed_month $total_month)"
printf "%-6s %-8s %s\n" "year"   "$(format_time year   $rem_year)"    "$(render_bar $elapsed_year $total_year)"
echo
