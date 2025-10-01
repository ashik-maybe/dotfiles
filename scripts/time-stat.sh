#!/bin/sh
#
# time-left — A zen view of your time.
#

# --- Date components ---
DAY_NAME=$(date '+%a')
MONTH_NAME=$(date '+%b')
DAY_NUM=$(date '+%-d')
HOUR_12=$(date '+%-I')
MINUTE=$(date '+%-M')
MERIDIEM=$(date '+%p')
YEAR=$(date '+%Y')
MONTH_NUM=$(date '+%-m')
DAY_OF_YEAR=$(date '+%-j')
DAY_OF_MONTH=$(date '+%-d')
HOUR_24=$(date '+%-H')
MIN_24=$(date '+%-M')

# Print header + blank line
printf '[%s, %s %s • %s:%s %s]\n\n' "$DAY_NAME" "$MONTH_NAME" "$DAY_NUM" "$HOUR_12" "$MINUTE" "$MERIDIEM"

# ===== TODAY =====
SECS_SINCE_MID=$((HOUR_24 * 3600 + MIN_24 * 60))
SECS_LEFT_TODAY=$((86400 - SECS_SINCE_MID))
[ $SECS_LEFT_TODAY -lt 0 ] && SECS_LEFT_TODAY=0

HOURS_LEFT=$((SECS_LEFT_TODAY / 3600))
MINUTES_LEFT=$(((SECS_LEFT_TODAY % 3600) / 60))

if [ $HOURS_LEFT -ge 1 ]; then
    if [ $MINUTES_LEFT -eq 0 ]; then
        TODAY_VAL="${HOURS_LEFT}h"
    else
        TODAY_VAL="${HOURS_LEFT}h ${MINUTES_LEFT}m"
    fi
else
    TODAY_VAL="${MINUTES_LEFT}m"
fi

PERCENT_TODAY=$((SECS_LEFT_TODAY * 100 / 86400))
printf 'Today:    %-17s (%d%% left)\n' "${TODAY_VAL} remaining" "$PERCENT_TODAY"

# ===== WEEK (ends Saturday, per NSU RA=Thu-Sat) =====
WEEKDAY_NUM=$(date '+%-u')  # Mon=1, ..., Sun=7
case $WEEKDAY_NUM in
    6) DAYS_LEFT_WEEK=0 ;;   # Saturday
    7) DAYS_LEFT_WEEK=6 ;;   # Sunday → next Sat in 6 days
    *) DAYS_LEFT_WEEK=$((6 - WEEKDAY_NUM)) ;;
esac
PERCENT_WEEK=$((DAYS_LEFT_WEEK * 100 / 7))

if [ $DAYS_LEFT_WEEK -eq 1 ]; then
    WEEK_STR="1 day left"
else
    WEEK_STR="${DAYS_LEFT_WEEK} days left"
fi
printf 'Week:     %-17s (%d%% left)\n' "$WEEK_STR" "$PERCENT_WEEK"

# ===== MONTH =====
case $MONTH_NUM in
    1|3|5|7|8|10|12) DIM=31 ;;
    4|6|9|11) DIM=30 ;;
    2)
        if [ $((YEAR % 4)) -eq 0 ] && { [ $((YEAR % 100)) -ne 0 ] || [ $((YEAR % 400)) -eq 0 ]; }; then
            DIM=29
        else
            DIM=28
        fi
        ;;
    *) DIM=30 ;;
esac

DAYS_LEFT_MONTH=$((DIM - DAY_OF_MONTH))
PERCENT_MONTH=$((DAYS_LEFT_MONTH * 100 / DIM))

WEEKS=$((DAYS_LEFT_MONTH / 7))
DAYS_REM=$((DAYS_LEFT_MONTH % 7))

if [ $WEEKS -eq 0 ]; then
    if [ $DAYS_REM -eq 1 ]; then
        MONTH_STR="1 day"
    else
        MONTH_STR="${DAYS_REM} days"
    fi
elif [ $DAYS_REM -eq 0 ]; then
    if [ $WEEKS -eq 1 ]; then
        MONTH_STR="1 week"
    else
        MONTH_STR="${WEEKS} weeks"
    fi
else
    if [ $WEEKS -eq 1 ]; then
        W_STR="1 week"
    else
        W_STR="${WEEKS} weeks"
    fi
    if [ $DAYS_REM -eq 1 ]; then
        D_STR="1 day"
    else
        D_STR="${DAYS_REM} days"
    fi
    MONTH_STR="$W_STR $D_STR"
fi
printf 'Month:    %-17s (%d%% left)\n' "$MONTH_STR" "$PERCENT_MONTH"

# ===== YEAR =====
leap() {
    y=$1
    [ $((y % 4)) -eq 0 ] && { [ $((y % 100)) -ne 0 ] || [ $((y % 400)) -eq 0 ]; }
}
leap "$YEAR" && DAYS_IN_YEAR=366 || DAYS_IN_YEAR=365
DAYS_LEFT_YEAR=$((DAYS_IN_YEAR - DAY_OF_YEAR))
PERCENT_YEAR=$((DAYS_LEFT_YEAR * 100 / DAYS_IN_YEAR))

# Approximate year as months (30-day avg)
MONTHS=$((DAYS_LEFT_YEAR / 30))
DAYS_REM=$((DAYS_LEFT_YEAR % 30))

if [ $MONTHS -eq 0 ]; then
    if [ $DAYS_REM -eq 1 ]; then
        YEAR_STR="1 day"
    else
        YEAR_STR="${DAYS_REM} days"
    fi
elif [ $DAYS_REM -eq 0 ]; then
    if [ $MONTHS -eq 1 ]; then
        YEAR_STR="1 month"
    else
        YEAR_STR="${MONTHS} months"
    fi
else
    if [ $MONTHS -eq 1 ]; then
        M_STR="1 month"
    else
        M_STR="${MONTHS} months"
    fi
    if [ $DAYS_REM -eq 1 ]; then
        D_STR="1 day"
    else
        D_STR="${DAYS_REM} days"
    fi
    YEAR_STR="$M_STR $D_STR"
fi
printf 'Year:     %-17s (%d%% left)\n' "$YEAR_STR" "$PERCENT_YEAR"
