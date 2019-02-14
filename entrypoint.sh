#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video

if [ $GID != $(echo `id -g qq`) ]; then
    groupmod -o -g $GID qq
fi
if [ $UID != $(echo `id -u qq`) ]; then
    usermod -o -u $UID qq
fi
chown qq:qq /TencentFiles

su qq <<EOF

function _exist(){
    if test $( pgrep -f $1 | wc -l ) -eq 0
    then
	echo "退出"
    else
	sleep 60
        _exist $1
    fi 
}

if [ "$1" ]; then
    echo "deepin-wine $1"
    deepin-wine $1
else
    echo "启动 $APP"
    mkdir -p /home/qq/.deepinwine
    touch /home/qq/.deepinwine/.QQ_run
    "/opt/deepinwine/apps/Deepin-$APP/run.sh"
    #tail -fn 0 /home/qq/.deepinwine/.QQ_run
    sleep 300
    _exist "QQProtect"
fi

exit 0
EOF
