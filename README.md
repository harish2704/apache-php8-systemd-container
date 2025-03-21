# apache-php8-systemd-container
A docker/podman container setup to run Apache-php vm simiar to a small VPS

This container image can emulate functionalities of an isolated Linux VPS server if used with Podman container management system instead of Docker.
because Podman has better support for Systemd than Docker


# Features

1. Very minimal Systemd based contrainer. Services can be started , stopped restarted inside container using starndard commands 
2. Apache with  PHP 8 and an Openssh server running on port 2022
3. Debian based container. It is easy to add addional softwares .

# Usage

### To quickly run a container
```sh
podman run --rm --name phptest -d -v ./www:/var/www ghcr.io/harish2704/apache-php8-systemd-container:latest
```

### To use inside a Coolify instance

This container image can be used to quickly spin new Apache-php VMs inside a Coolify instance.
But for this to work, Coolify instance should run using Podman instead of Docker.
If you have such a Coolify instance, Create a new resource using Docker-compose and use the following 

```docker-compose

services:
  os:
    image: 'ghcr.io/harish2704/apache-php8-systemd-container:latest'
    tty: true
    volumes:
      - 'srvroot:/var/www'
      - 'apacheconf:/etc/apache2'
      - 'phpconf:/usr/local/etc/php'
      -
        type: bind
        source: ./authorized_keys
        target: /root/.ssh/authorized_keys
        content: "# Authorized keys\n"
    ports:
      - '${PUBLIC_SSH_PORT}:2022'
    environment:
      - container=podman
      - 'SSH_PUBLIC_PORT=${PUBLIC_SSH_PORT:-10022}'
volumes:
  srvroot: null
  apacheconf: null
  phpconf: null

```

In this way, we will get a VM with 
1. Apache+php8 web server ( Automatic https will be handled by Coolify if configured properly )
2. SSH access to the VM using configurable port ( Default port 10022 ). Port can be changed in Env section
3. A Linux server like environment based on Debian where services are managed by systemd and softwares can be add/removed using apt




