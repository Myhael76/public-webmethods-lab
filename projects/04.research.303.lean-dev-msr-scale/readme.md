# Research project 303 scale MSR nodes

This project shows how MSR nodes can be scaled dynamically

## Prerequisites

Project 01.build.011.LeanMSR

## Execute

```bat
docker-compose up
```

In a browser open http://host.docker.internal:30355/invoke/wm.server.admin/getServerHost

```bat
docker-compose up --scale msr-303=3
```

Refresh the browser page repeatedly to observe the change in the responding hostname
