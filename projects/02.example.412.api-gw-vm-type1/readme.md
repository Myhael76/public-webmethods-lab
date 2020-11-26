# Virtual Machine on Docker for API Gateway

## Purpose

This project is an example on how to setup API Gateway on a VM and as a helper for authoring the setup scripts. It is not intended as a example of docker based API Gateway usage.

## IMPORTANT

This docker "machine" will work only if the host increments the kernel parameters as per API Gateway requirements

Example for Docker Desktop on WSL2:

Open a power shell and issue command wsl (assuming the default distirbution is docker-desktop)

```powershell

wsl -l

Windows Subsystem for Linux Distributions:
docker-desktop (Default)
docker-desktop-data

wsl
```

then

```bash
sysctl -w fs.file-max=200000
sysctl -w vm.max_map_count=262144
sysctl -p
mkdir /etc/security
echo "sagadmin soft nofile 65536" >> /etc/security/limits.conf
echo "sagadmin hard nofile 65536" >> /etc/security/limits.conf
echo "sagadmin soft nproc 4096" >> /etc/security/limits.conf
echo "sagadmin hard nproc 4096" >> /etc/security/limits.conf
```

Restart Docker Desktop