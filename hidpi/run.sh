#!/bin/sh

docker cp logpixels.reg qq:/
docker exec -it qq  su qq -c 'WINEPREFIX=/home/qq/.deepinwine/Deepin-$APP deepin-wine regedit /logpixels.reg'
