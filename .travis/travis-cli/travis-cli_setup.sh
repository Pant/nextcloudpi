#!/bin/bash

docker build . -t travis-cli
echo "alias travis='./.travis/travis-cli/travis-cli.sh'" >> ~/.bashrc

