# Cronjob Docker Container

## Overview

This Docker container is designed to run scheduled tasks, also known as cron jobs, as well as to periodically execute scripts. Built on top of Alpine Linux, it aims to be lightweight, flexible, and secure. Scripts located in the `/cron_scripts` directory (or as specified by the `TASK_DIR` environment variable) will be executed based on the cron schedule you configure.

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
docker run -v /path/to/scripts:/cron_scripts ghcr.io/eqe-lab/cronjob:latest
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

- `TASK_DIR`: Specifies the directory where the periodic task scripts are located. The default directory is `/cron_scripts`. Shell scripts in this directory should follow the filename format: `[0-9][0-9][0-9][_-]*.sh`.
- `RUN_SPECIFIC_TASK`: If set, the container will only execute the specified script. By default, this is empty, and all scripts in the `TASK_DIR` will be executed.
- `DOCKER_EXEC_USER`: The user to execute the command as when running in a Docker container.
- `DOCKER_EXEC_SHELL`: The shell to use when executing the command in a Docker container.
- `DOCKER_EXEC_SHELL_ARGS`: Additional arguments for the shell when executing the command in a Docker container.
- `LOCAL_EXEC`: If set to `true`, the scripts will be executed locally instead of in a Docker container.
## Advanced Configuration

### Entry Points Scripts

The container allows for additional initialization scripts to be executed before the cron jobs start. Place your scripts in a directory and mount it to `/entrypoints.d` in the container. The scripts should be named following the pattern `[0-9][0-9][0-9]*.sh` and will be executed in numerical order.

#### Environment Variables

- `ENTRYPOINTS_DIR`: Specifies the directory where the entry point scripts are located. Defaults to `/entrypoints.d`.

#### Example

To execute additional initialization scripts, you can mount a local directory to `/entrypoints.d` in your `docker-compose.yml`:

```yaml
volumes:
  - ./my-entrypoints:/entrypoints.d
```

Or using Docker command:

```bash
docker run -v /path/to/my-entrypoints:/entrypoints.d ghcr.io/eqe-lab/cronjob:latest
```



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
