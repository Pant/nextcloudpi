#!/bin/bash

set -o errexit

echo "INFO:
Install pip for python3 and using pip install selenium
for python tests.
Download geckodriver latest release for Firefox web 
driver which is being used inside the test scripts and
export path.
"

sudo apt-get install python3-pip
sudo python3 -m pip install selenium
wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz
tar -xvzf geckodriver*
chmod +x geckodriver
export PATH=$PATH:$PWD
