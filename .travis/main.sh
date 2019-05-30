#!/bin/bash

#set -o errexit

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

  #Enable experimental features
  echo $'{\n    "experimental": true\n}' | sudo tee /etc/docker/daemon.json
  sudo service docker restart

  #Get latest version of Docker (18.09) that supports all experimental features
  #Convenience script not always working
  #  curl -fsSL https://get.docker.com -o get-docker.sh
  #  sudo sh get-docker.sh
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce

  #Checking if Docker version is 18.09
  docker version
  sudo cat /etc/docker/daemon.json
  printenv | grep DOCKER
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
