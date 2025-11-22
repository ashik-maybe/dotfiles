#!/usr/bin/env bash

# Check for -t flag
newline_output=false
[[ "$1" == "-t" ]] && newline_output=true

now=$(date +%s)

# Day of week (1=Mon, ..., 7=Sun)
dow=$(date +%u)
days_since_sunday=$(( dow % 7 ))  # Sunday = 0
start_of_week=$(date -d "$days_since_sunday days ago" +%Y-%m-%d)
end_week=$(date -d "$start_of_week +6 days 23:59:59" +%s)  # Saturday night

# Boundaries
end_today=$(date -d 'tomorrow 00:00' +%s)
end_month=$(date -d "$(date +%Y-%m-01) +1 month -1 day 23:59:59" +%s)
end_year=$(date -d "$(date +%Y)-12-31 23:59:59" +%s)

# Remaining time today
min_today=$(( (end_today - now) / 60 ))
hr_today=$(( min_today / 60 ))
phrase_today="${hr_today}h left today"

# Remaining time this week
sec_left_week=$(( end_week - now ))
if (( sec_left_week <= 0 )); then
  phrase_week="Weekend just started"
else
  days_left_week=$(( sec_left_week / 86400 ))
  hrs_left_week=$(( (sec_left_week % 86400) / 3600 ))

  if (( days_left_week == 0 && hrs_left_week <= 6 )); then
    phrase_week="Final hours of the week"
  elif (( days_left_week == 0 )); then
    phrase_week="${hrs_left_week}h left this week"
  else
    phrase_week="${days_left_week}d"
    [[ $hrs_left_week -gt 0 ]] && phrase_week+=" + ${hrs_left_week}h"
    phrase_week+=" left this week"
  fi
fi

# Remaining time this month
day_month=$(( (end_month - now) / 86400 ))
if (( day_month >= 7 )); then
  weeks_month=$(( day_month / 7 ))
  extra_days_month=$(( day_month % 7 ))
  phrase_month="${weeks_month}w"
  [[ $extra_days_month -gt 0 ]] && phrase_month+=" + ${extra_days_month}d"
  phrase_month+=" left this month"
elif (( day_month == 1 )); then
  phrase_month="Final day of the month"
else
  phrase_month="${day_month}d left this month"
fi

# Remaining time this year
days_year=$(( (end_year - now) / 86400 ))
months_year=$(( days_year / 30 ))
extra_days_year=$(( days_year % 30 ))
target_year=$(date -d "@$end_year" +%Y)
current_year=$(date +%Y)

if (( months_year >= 1 )); then
  phrase_year="${months_year}mo"
  [[ $extra_days_year -gt 0 ]] && phrase_year+=" + ${extra_days_year}d"
else
  phrase_year="${days_year}d"
fi

if (( target_year > current_year )); then
  phrase_year+=" till $target_year"
else
  phrase_year+=" left this year"
fi

# Final output
if $newline_output; then
  echo -e "\t$phrase_today"
  echo -e "\t$phrase_week"
  echo -e "\t$phrase_month"
  echo -e "\t$phrase_year"
else
  echo -e "\t$phrase_today • $phrase_week • $phrase_month • $phrase_year"
fi
