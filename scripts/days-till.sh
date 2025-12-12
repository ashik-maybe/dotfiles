#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo
  read -r -p "Enter a future date/time: " input
  echo
  [[ -z "$input" ]] && { echo "Canceled." >&2; exit 1; }
else
  input="$*"
fi

target_sec=$(date -d "$input" +%s 2>/dev/null)
if [[ $? -ne 0 ]]; then
  echo "Unrecognized date: '$input'" >&2
  exit 1
fi

target_formatted=$(date -d "@$target_sec" +"%A, %B %d, %Y at %I:%M %p" 2>/dev/null)
now_sec=$(date +%s)

if (( target_sec <= now_sec )); then
  echo
  echo "The specified time is in the past:"
  echo "  $target_formatted"
  exit 0
fi

diff_sec=$((target_sec - now_sec))

years=$(( diff_sec / 31536000 ))
rem=$(( diff_sec % 31536000 ))

months=$(( rem / 2592000 ))
rem=$(( rem % 2592000 ))

days=$(( rem / 86400 ))
rem=$(( rem % 86400 ))

hours=$(( rem / 3600 ))
rem=$(( rem % 3600 ))

minutes=$(( rem / 60 ))
seconds=$(( rem % 60 ))

fmt() {
  local n=$1 unit=$2
  if (( n == 1 )); then
    echo "$n $unit"
  else
    echo "$n ${unit}s"
  fi
}

parts=()
(( years   > 0 )) && parts+=("$(fmt $years year)")
(( months  > 0 )) && parts+=("$(fmt $months month)")
(( days    > 0 )) && parts+=("$(fmt $days day)")
(( hours   > 0 )) && parts+=("$(fmt $hours hour)")
(( minutes > 0 )) && parts+=("$(fmt $minutes minute)")
(( seconds > 0 )) && parts+=("$(fmt $seconds second)")

# 🔑 Always add a leading newline before showing result
echo
echo "Time until $target_formatted:"
if [[ ${#parts[@]} -eq 0 ]]; then
  echo "  Now"
else
  (IFS=' '; echo "  ${parts[*]}")
fi
