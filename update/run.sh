#!/bin/sh

sudo docker start qq
sudo docker cp update.sh qq:/
sudo docker exec -it qq mv -v /entrypoint.sh /entrypoint.sh.bk
sudo docker exec -it qq mv -v /update.sh /entrypoint.sh
sudo docker restart qq
sudo docker logs -f qq
sudo docker start qq
