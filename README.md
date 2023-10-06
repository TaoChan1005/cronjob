# Cronjob Docker Container

## Overview

This Docker container is designed to run scheduled tasks, also known as cron jobs. It is built on top of Alpine Linux and is intended to be lightweight, flexible, and secure.

## Features

- **Lightweight**: Built on Alpine Linux.
- **Flexible**: Can be used with any application that requires scheduled tasks.
- **Secure**: Runs tasks as a non-root user for added security.

## Quick Start

### Using Docker Compose

Create a `docker-compose.yml` file with the following content:

```yaml
version: "3.7"

services:

  cronjob:
    image: ghcr.io/eqe-lab/cronjob:latest
    container_name: cronjob
    restart: unless-stopped
    volumes:
      - ${CRON_BASE_DIR:-./cron}/scripts:/cron_scripts:ro
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      DEBUG: ${DEBUG:-"false"}
      LOCAL_EXEC: true


```

Then run:

```bash
docker-compose up -d
```

### Using Docker Command

```bash
docker run -e RUN_ON_STARTUP=true ghcr.io/eqe-lab/cronjob:latest
```

## Environment Variables

- `RUN_ON_STARTUP`: If set to `true`, the cron job will run once upon container startup.

## Customizing Cron Jobs

You can add your custom tasks by mounting your own cron scripts to `/path/to/scripts`.

```bash
docker run -v /path/to/scripts:/custom-scripts ghcr.io/eqe-lab/cronjob:latest
```

## Environment Variables

### General Configuration

- `RUN_ON_STARTUP`: If set to `true`, the cron job will run once upon container startup.

### Task Scheduling

- `EXEC_INTERVAL_DAY`: The interval in days at which the cron job should run. Default is `0`.
- `EXEC_INTERVAL_HOUR`: The interval in hours at which the cron job should run. Default is `0`.
- `EXEC_INTERVAL_MINUTE`: The interval in minutes at which the cron job should run. Default is `5`.

### Custom Cron Period

- `CRON_PERIOD`: Allows you to set a custom cron schedule. If not set, it will be generated based on `EXEC_INTERVAL_DAY`, `EXEC_INTERVAL_HOUR`, and `EXEC_INTERVAL_MINUTE`.

### Debugging

- `DEBUG`: Set to `"true"` to enable debugging. This will print additional information during the container startup and task execution.

### Script Execution

- `DOCKER_EXEC_USER`: The user to execute the command as when running in a Docker container.
- `DOCKER_EXEC_SHELL`: The shell to use when executing the command in a Docker container.
- `DOCKER_EXEC_SHELL_ARGS`: Additional arguments for the shell when executing the command in a Docker container.
- `LOCAL_EXEC`: If set to `true`, the scripts will be executed locally instead of in a Docker container.


### Example

Here's how you can set these variables using Docker Compose:

```yaml
environment:
  DEBUG: "true"
  EXEC_INTERVAL_DAY: 1
  EXEC_INTERVAL_HOUR: 0
  EXEC_INTERVAL_MINUTE: 30
```


## Contributing

Contributions are welcome! Feel free to open Pull Requests or Issues.

## License

This project is licensed under the MIT License.
