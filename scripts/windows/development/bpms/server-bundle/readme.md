# BPMS Server bundle

This folder is provided as a helper for local development environments for BPMS.

**WORK IN PROGRESS**

All docker-compese files must remain in the same directory, otherwise the containers will not communicate.

## Database server preparation

Steps to follow for a quick start:

- execute pullImages.bat to ensure you access the needed images
  - Note: the wm-dcc:10.5 image is not public for the moment
- execute mysql_up
- execute adminer_up (db client, keep it up only when needed)
- execute alpine_dbcc_create-all

You should now have a working mysql database server intialized with all webmethods components.

Eventually cleanup intermediary images, such as:

```bat
<none>:<none>
REM contextually created for mydbcc:10.5

*.sag/wm-dcc:10.5
REM not needed anymore if you have mydbcc:10.5 working
```
