# Virtual Machine on Docker for API Gateway

## Purpose

This project is an example on how to setup API Gateway on a VM and as a helper for authoring the setup scripts. It is not intended as an example of docker based API Gateway usage.

## IMPORTANT

This docker "machine" will work only if the host increments the kernel parameters as per API Gateway requirements.

The simplest way to do this is to run [this project](https://github.com/Myhael76/sag-unattented-installations/tree/main/04.support/alpine-set-elk-prerequisites).

Alternatively, if Docker Desktop is used, the following procedure may be considered.

Note: change of fs.file-max to 200000 is documented, but it does not seem to be necessary for simple deployments.

Example for Docker Desktop on WSL2:

Open a power shell and issue command wsl

Ensure assuming the default distribution is docker-desktop

```powershell

wsl -l

Windows Subsystem for Linux Distributions:
docker-desktop (Default)
docker-desktop-data

# eventually
wsl --setdefault docker-desktop

wsl
```

then

```bash
# for the current session only
sysctl -w fs.file-max=200000
sysctl -w vm.max_map_count=262144

sysctl -p
```

Or plan for permanent change:

```bash
# or permanently
vi /etc/sysctl.conf

```

Then add/modify in the file the following two rows and save

```text
vm.max_map_count=262144
fs.file-max=200000
```


Obviously, if the file already exists for other reasons, edit and change the values accordingly.

Restart Docker Desktop

