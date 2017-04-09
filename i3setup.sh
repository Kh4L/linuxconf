#!/bin/bash

set -ue

cat files/i3config >> ~/.config/i3/config

sudo cp files/i3status.conf /etc/i3status.conf
GREEN='\e[32m'

echo -e '\e[32mi3 ready\e[39m'
