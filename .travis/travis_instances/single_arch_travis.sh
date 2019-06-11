#!/bin/bash

echo "Which arch would you like to build?"
echo "x86/armhf/arm64"
read arch

cp travis_docker.yml travis_${arch}.yml

if [[ "$arch" != "x86" ]]; then

  [[ "$arch" == armhf ]] && sed -i "s/amd64/armhf/g" travis_${arch}.yml && sed -i "s/arch_qemu=x86_64/arch_qemu=arm/" travis_${arch}.yml
  [[ "$arch" == arm64 ]] && sed -i "s/amd64/arm64v8/g" travis_${arch}.yml && sed -i "s/arch_qemu=x86_64/arch_qemu=aarch64/" travis_${arch}.yml

  sed -i "s/x86/${arch}/g" travis_${arch}.yml
  sed -i "22s,#,," travis_${arch}.yml
  sed -i "38s,#,," travis_${arch}.yml
  sed -i "55s,#,," travis_${arch}.yml
  sed -i "81s,#,," travis_${arch}.yml
fi

echo "Your produced travis file is: $PWD/travis_${arch}.yml"
