#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
groupmod -o -g $GID qq
if [ $UID != $(echo `id -u qq`) ]; then
    usermod -o -u $UID qq
fi
chown -R qq:qq /TencentFiles
chown -R qq:qq /home/qq

su qq <<EOF
if [ "$1" ]; then
    echo "deepin-wine $1"
    deepin-wine $1
else
    echo "启动 $APP"
    /run.sh
fi

exit 0
EOF