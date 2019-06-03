#!/bin/bash

set -o errexit

echo "INFO:
Add qemu-user package to run a qemu instance in user mode 
and binfmt-support to expand the binfmt_misc handler so 
that it recognises arm executables and use qemu-arm 
entry as the interpreter
"
sudo apt-get --yes --no-install-recommends install binfmt-support qemu-user-static
