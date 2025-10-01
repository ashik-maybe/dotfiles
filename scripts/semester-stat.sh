#!/bin/bash

set -euo pipefail

CONFIG_FILE="$HOME/.academic-calendar.json"

show_help() {
  cat <<EOF
Usage: semester [OPTIONS]

Track academic progress using ~/.academic-calendar.json.

Options:
  --help     Show help and JSON template

Required JSON (~/.academic-calendar.json):
{
  "semester": "Fall 2025",
  "start_date": "2025-09-18",
  "end_date": "2025-12-24",
  "tuition_deadline_no_late_fee": "2025-10-15",
  "finals_start": "2025-12-18"
}
EOF
}

[[ "${1:-}" == "--help" ]] && { show_help; exit 0; }

[[ ! -f "$CONFIG_FILE" ]] && {
  echo "Error: $CONFIG_FILE not found. Run 'semester --help' for format."
  exit 1
}

get_json_value() {
  grep -o "\"$1\"\s*:\s*\"[^\"]*\"" "$CONFIG_FILE" 2>/dev/null | sed -E 's/.*"([^"]*)".*/\1/' | head -n1
}

SEMESTER=$(get_json_value "semester")
START=$(get_json_value "start_date")
END=$(get_json_value "end_date")
TUITION=$(get_json_value "tuition_deadline_no_late_fee")
FINALS=$(get_json_value "finals_start")

# Validate required fields
for f in semester start_date end_date; do
  [[ -z "$(get_json_value "$f")" ]] && { echo "Missing field: $f"; exit 1; }
done

# Parse dates
today_sec=$(date +%s)
start_sec=$(date -d "$START" +%s 2>/dev/null || { echo "Invalid start_date"; exit 1; })
end_sec=$(date -d "$END" +%s 2>/dev/null || { echo "Invalid end_date"; exit 1; })

(( start_sec > end_sec )) && { echo "Error: start_date after end_date"; exit 1; }

# Semester ended?
if (( today_sec > end_sec )); then
  echo "⚠️  Semester '$SEMESTER' ended on $END!"
  echo "→ Please update $CONFIG_FILE."
  exit 0
fi

# Not started yet?
if (( today_sec < start_sec )); then
  days=$(( (start_sec - today_sec) / 86400 ))
  echo "📚 $SEMESTER (starts in $days d)"
  exit 0
fi

# During semester
elapsed=$(( (today_sec - start_sec) / 86400 ))
total_days=$(( (end_sec - start_sec) / 86400 + 1 ))
remaining=$(( total_days - elapsed - 1 ))
(( remaining < 0 )) && remaining=0

# Progress %
progress_x10=$(( total_days > 0 ? elapsed * 1000 / total_days : 0 ))
progress_int=$(( progress_x10 / 10 ))
progress_frac=$(( progress_x10 % 10 ))

# OUTPUT EXACTLY AS REQUESTED
echo "📚 $SEMESTER ($progress_int.$progress_frac%)"
echo "⏳ Days gone: $elapsed d / $remaining d"

# Tuition
if [[ -n "$TUITION" ]]; then
  tuition_sec=$(date -d "$TUITION" +%s 2>/dev/null || { echo "Invalid tuition date"; exit 1; })
  if (( today_sec <= tuition_sec )); then
    days=$(( (tuition_sec - today_sec) / 86400 ))
    echo "💰 Tuition deadline: $days d"
  else
    echo "💰 Tuition deadline: overdue"
  fi
fi

# Finals
if [[ -n "$FINALS" ]]; then
  finals_sec=$(date -d "$FINALS" +%s 2>/dev/null || { echo "Invalid finals date"; exit 1; })
  if (( today_sec <= finals_sec )); then
    days=$(( (finals_sec - today_sec) / 86400 ))
    echo "🎯 Finals start in: $days d"
  elif (( today_sec <= end_sec )); then
    echo "🎯 Finals start in: now"
  fi
fi
