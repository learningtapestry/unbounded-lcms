#!/usr/bin/env bash

apt-get install fontconfig -y
cp -R "${STACK_PATH}/app/assets/fonts/*" /usr/local/share/fonts
fc-cache -f -v
