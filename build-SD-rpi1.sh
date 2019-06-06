#!/bin/bash

# Batch creation of NextCloudPi image
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage: ./batch.sh <DHCP QEMU image IP>
#

set -e
source buildlib.sh

SIZE=3G                     # Raspbian image size
#CLEAN=0                    # Pass this envvar to skip cleaning download cache
IMG="NextCloudPi_RPi_$( date  "+%m-%d-%y" ).img"

##############################################################################

pgrep -f qemu-arm-static &>/dev/null && { echo "qemu-arm-static already running. Abort"; exit 1; }

## preparations

IMG=tmp/"$IMG"

prepare_dirs                   # tmp cache output
download_raspbian "$IMG"
resize_image      "$IMG" "$SIZE"
update_boot_uuid  "$IMG"       # PARTUUID has changed after resize

