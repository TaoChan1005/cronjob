#!/usr/bin/env bash

docker_exec_no_shell() {
    containerId="$1"; shift

    # If a user must be specified when executing the task, set up that option here.
    # You may also leave DOCKER_EXEC_USER blank, in which case it will not be used.
    if [[ -n "$DOCKER_EXEC_USER" ]]; then
        exec_user="--user $DOCKER_EXEC_USER"
    fi
    CMD="docker exec $exec_user "$containerId" "$@""
    echo "> Executing: $CMD"
    docker exec $exec_user "$containerId" "$@"
    
}

docker_exec() {
    containerId="$1"; shift
    _file="$2"
    if [ -f "$_file" ]; then
        shell=$(cat "$_file")
    else
        shell="$@"
    fi
    docker_exec_no_shell "$containerId" "$DOCKER_EXEC_SHELL" $DOCKER_EXEC_SHELL_ARGS "$shell"
}

local_exec() {
    echo "> Executing locally: eval $@"
    eval "$@" || true
}

_exec() {
    _LOCAL="$1"; shift

    if [ $LOCAL_EXEC = "true" ]; then
        local_exec "$@" || true
    else
        docker_exec "$containerId" "$@" || true
    fi
}