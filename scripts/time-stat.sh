#!/usr/bin/env bash

now=$(date +%s)

# Boundaries
end_today=$(date -d 'tomorrow 00:00' +%s)
end_week=$(date -d 'next friday 23:59:59' +%s)  # Week ends Friday night
end_month=$(date -d "$(date +%Y-%m-01) +1 month -1 day 23:59:59" +%s)
end_year=$(date -d "$(date +%Y)-12-31 23:59:59" +%s)

# Remaining time
min_today=$(( (end_today - now) / 60 ))
hr_today=$(( min_today / 60 ))

# Week
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

# Month
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

# Year
days_year=$(( (end_year - now) / 86400 ))
months_year=$(( days_year / 30 ))
extra_days_year=$(( days_year % 30 ))
if (( months_year >= 1 )); then
  phrase_year="${months_year}mo"
  [[ $extra_days_year -gt 0 ]] && phrase_year+=" + ${extra_days_year}d"
  phrase_year+=" till $(date -d "@$end_year" +%Y)"
else
  phrase_year="${days_year}d till $(date -d "@$end_year" +%Y)"
fi

# Today
phrase_today="${hr_today}h left today"

# Final output
echo "$phrase_today • $phrase_week • $phrase_month • $phrase_year"
