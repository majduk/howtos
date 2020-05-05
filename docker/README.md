# Docker

## Stress test
Dockerfile:
```
FROM python:3.7-alpine
RUN apk add --no-cache stress-ng
CMD ["/usr/bin/stress-ng", "-c", "1"]
```
docker-compose.yml:
```
version: '3'
services:
  web:
    build: .
    deploy:
      resources:
        #cpuset: 1
        reservations:
          cpus: '0.5'
```
Run: `docker-compose build .` and `docker-compose up`

## CPU Affinity

Create systemd override file at `/etc/systemd/system/docker.service.d/override.conf`:
```
[Service]
ExecStartPre=/bin/mkdir -p /sys/fs/cgroup/cpuset/docker
ExecStartPre=/bin/bash -c '/bin/echo 1 > /sys/fs/cgroup/cpuset/docker/cpuset.cpus'
ExecStopPost=/bin/rmdir /sys/fs/cgroup/cpuset/docker
```
