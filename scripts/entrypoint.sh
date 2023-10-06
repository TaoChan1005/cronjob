#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

if [ -z "$EXEC_INTERVAL_DAY" ]; then
    EXEC_INTERVAL_DAY=0
fi

if [ -z "$EXEC_INTERVAL_HOUR" ]; then
    EXEC_INTERVAL_HOUR=0
fi

if [ -z "$EXEC_INTERVAL_MINUTE" ]; then
    EXEC_INTERVAL_MINUTE=5
fi

if [ $EXEC_INTERVAL_DAY -gt 0 ]; then
    DAY_SYMBOL="*/$EXEC_INTERVAL_DAY"
else
    DAY_SYMBOL="*"
fi

if [ $EXEC_INTERVAL_HOUR -gt 0 ]; then
    HOUR_SYMBOL="*/$EXEC_INTERVAL_HOUR"
else
    HOUR_SYMBOL="*"
fi

if [ $EXEC_INTERVAL_MINUTE -gt 0 ]; then
    MINUTE_SYMBOL="*/$EXEC_INTERVAL_MINUTE"
else
    MINUTE_SYMBOL="*"
fi

if [ -z "$CRON_PERIOD" ]; then
    CRON_PERIOD="$MINUTE_SYMBOL $HOUR_SYMBOL $DAY_SYMBOL * *"
fi

CRON_FILE=/var/spool/cron/crontabs/root
CRON_TASK_FILE=$WORK_DIR/cron.sh
CRON_TASK_CMD="$CRON_PERIOD $CRON_TASK_FILE"
PRE_TASK_FILE=$WORK_DIR/pre_task.sh

bash $PRE_TASK_FILE
echo "-------------------------------------------------------------"
echo "> Start at : $(date)"
echo "-------------------------------------------------------------"
if [ $RUN_ON_STARTUP == "true" ]; then
    echo "> manual excute: $CRON_TASK_FILE which whould excute all the *.sh in $TASK_DIR/"
    bash $CRON_TASK_FILE
    echo "-------------------------------------------------------------"
fi

echo "> Cron task: $CRON_TASK_CMD"
echo "$CRON_TASK_CMD" > $CRON_FILE

echo "> Starting crond"
exec crond -f -l 0