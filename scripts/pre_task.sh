#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

if [ -z $ENTRYPOINTS_DIR ]; then  # Added a semicolon here
    ENTRYPOINTS_DIR="/entrypoints.d"
fi

# New section to check for scripts in /entrypoints.d and execute them
if [ -d "$ENTRYPOINTS_DIR" ]; then
    echo "-------------------------------------------------------------"
    echo "> Execute PRE TASK at : $(date)"
    echo "-------------------------------------------------------------"
    echo "> Checking for scripts in $ENTRYPOINTS_DIR"
    i=0
    for script in $(ls $ENTRYPOINTS_DIR/[0-9][0-9][0-9]*.sh 2>/dev/null | sort); do  # Changed to variable
        echo "> Executing $script"
        bash $script
        i=$((i+1))
    done
    if [ $i -eq 0 ]; then
        echo "> No scripts found in $ENTRYPOINTS_DIR"
    else
        echo "> Executed $i scripts in $ENTRYPOINTS_DIR"
    fi
    echo "=============================================================="
fi
