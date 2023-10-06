# Use lightweight Alpine Linux as the base image
FROM alpine

# Install necessary packages: Docker CLI, Bash, and Tini
RUN apk add --no-cache docker-cli bash tini

# Set environment variables
ENV DOCKER_EXEC_USER=www-data \
    DOCKER_CONTAINER_NAME= \
    DOCKER_PROJECT_NAME= \
    CRON_MINUTE_INTERVAL=15 \
    DOCKER_EXEC_SHELL=bash \
    DOCKER_EXEC_SHELL_ARGS=-c \
    TASK_DIR=/cron_scripts \
    WORK_DIR=/cron \
    LOCAL_EXEC=true \
    RUN_ON_STARTUP=true \
    RUN_SPECIFIC_TASK= \
    $ENTRYPOINTS_DIR=/entrypoints.d

# Set the working directory
WORKDIR $WORK_DIR

# Add scripts to the working directory
ADD scripts/*.sh $WORK_DIR/

# Create the task directory and move the entrypoint and healthcheck scripts
RUN mkdir -p $TASK_DIR && \
    mv $WORK_DIR/entrypoint.sh /entrypoint.sh && \
    mv $WORK_DIR/healthcheck.sh /healthcheck.sh

# Set the entrypoint
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

# Set the health check
HEALTHCHECK --timeout=5s CMD ["/healthcheck.sh"]
