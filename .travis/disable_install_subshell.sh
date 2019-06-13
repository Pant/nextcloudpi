#!/bin/bash

echo "Disabling subshell for install command in etc/library"

sed -i "s,(install),install," ../etc/library.sh

