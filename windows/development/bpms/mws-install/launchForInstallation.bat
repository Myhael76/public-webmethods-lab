docker run -ti --rm^
 --entrypoint="/bin/bash"^
 --name centos-wm-install-helper-mws^
 --hostname centos-wm-install-helper-mws^
 -v /var/run/docker.sock:/var/run/docker.sock^
 -v ../../lib/:/mnt/base-libs/^
 centos-wm-install-helper
 
pause