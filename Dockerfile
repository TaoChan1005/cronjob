FROM alpine

# Mdodyfied from : https://github.com/rcdailey/FIREFLY_III-cronjob
RUN apk add --no-cache docker-cli bash tini

ENV DOCKER_EXEC_USER=www-data
ENV DOCKER_CONTAINER_NAME=
ENV DOCKER_PROJECT_NAME=
ENV CRON_MINUTE_INTERVAL=15
ENV DOCKER_EXEC_SHELL=bash
ENV DOCKER_EXEC_SHELL_ARGS=-c
ENV TASK_DIR=/cron_scripts
ENV WORK_DIR=/cron
ENV LOCAL_EXEC=true


WORKDIR $WORK_DIR
ADD cron/*.sh $WORK_DIR/

# RUN mkdir -p $WORK_DIR \
RUN mkdir -p $TASK_DIR \
    && mv /cron/entrypoint.sh /entrypoint.sh \
    && mv /cron/healthcheck.sh /healthcheck.sh

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

HEALTHCHECK --timeout=5s \
    CMD ["/healthcheck.sh"]