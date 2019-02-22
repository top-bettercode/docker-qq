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
   echo "启动 $APP"
   mkdir -p /home/qq/.deepinwine
   touch /home/qq/.deepinwine/.QQ_run
   "/opt/deepinwine/apps/Deepin-$APP/run.sh"
   sleep 300
EOF

#tail -fn 0 /home/qq/.deepinwine/.QQ_run
while test -n "`pidof QQProtect.exe`"
do
    sleep 60
done
echo "退出"
