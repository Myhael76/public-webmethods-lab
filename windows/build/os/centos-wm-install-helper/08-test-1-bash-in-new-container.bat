
docker run -ti --rm^
 --entrypoint="/bin/bash"^
 --name centos-wm-install-helper-test-1^
 --hostname centos-wm-install-helper-test-1^
 -v /var/run/docker.sock:/var/run/docker.sock^
 centos-wm-install-helper

pause