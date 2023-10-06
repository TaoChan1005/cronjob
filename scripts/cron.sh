#!/usr/bin/env bash
set -e
[[ ! -z "$DEBUG" ]] && set -x

source $WORK_DIR/_exec.sh

echo "-------------------------------------------------------------"
echo "> Executing Cron Tasks: $(date)"
echo "-------------------------------------------------------------"

# Obtain the ID of the container. We do this each iteration since the container may be
# recreated while the cron container is still running. We will need to check for a new container ID
# each time.
if [ $LOCAL_EXEC != "true" ]; then
    containerId="$($WORK_DIR/find_container.sh)"
    if [[ -z "$containerId" ]]; then
        echo "ERROR: Unable to find the container"
        exit 1
    fi
    echo "> Container ID: ${containerId}"
fi

run_scripts_in_dir() {
    # ALL_SHELLS=`ls -l "$1" | awk '/^-.*[0-9][0-9][0-9]-[A-Za-z]+\.sh$/ {print $NF}' `
    # ALL_SHELLS=$(ls -l "$1" | awk '/^-.*.sh$/ {print $NF}')
    # 
    ALL_SHELLS=$(ls -l "$1" | awk '/^-.*[0-9]{3}[-_].+\.sh$/ {print $NF}')
    echo "> Found $(echo $ALL_SHELLS | wc -w) scripts: $(echo $ALL_SHELLS | tr '\n' ' ')"
    i=0
    for shell in $ALL_SHELLS; do
        echo "> Running Script: $shell"
        _exec $LOCAL_EXEC "$containerId" "$1/$shell" || true
        i=$(expr ${i} + 1)
    done
    echo "> Finished $i scripts"
}

# Loop through all shell scripts and execute the contents of those scripts in the Nextcloud
# container.
run_scripts_in_dir $TASK_DIR

echo "> Done"
