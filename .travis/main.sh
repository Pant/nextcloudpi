#!/bin/bash

set -o errexit

main() {
  update_docker_configuration
  add_packages_for_arm_architecture

  echo "SUCCESS:
  Done! Finished setting up Travis machine.
  "
}

update_docker_configuration() {
  echo "INFO:
  Updating docker configuration
  "
  #Get latest version of Docker (18.09) that supports all experimental features
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh

  #Enable experimental features
  echo $'{\n    "experimental": true\n}' | sudo tee /etc/docker/daemon.json
#  echo '{
#  "experimental": true,
#  "storage-driver": "overlay2",
#  "max-concurrent-downloads": 50,
#  "max-concurrent-uploads": 50
#}' | sudo tee /etc/docker/daemon.json
  sudo service docker restart
 # export DOCKER_CLI_EXPERIMENTAL=enabled
}

add_packages_for_arm_architecture() {
  echo "INFO:
  Add qemu-user package to run a qemu instance in user mode 
  and binfmt-support to expand the binfmt_misc handler so 
  that it recognises arm executables and use qemu-arm 
  entry as the interpreter
  "
  sudo apt-get --yes --no-install-recommends install binfmt-support qemu-user-static
}

main
