#!/bin/sh



id=bestwu/qq
# array=(`wget -q https://registry.hub.docker.com/v1/repositories/$id/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | sed 's/\n/\n/g'`)
# array=(im light office)
# for item in "${array[@]}"
# do
#     echo "$item"
#     sudo docker pull $id:$item
#     # sudo docker tag $id:$tag $id:$newtag
#     # sudo docker images
#     # sudo docker push $id:$newtag
# done

tag=light
newtag=light-7.9-14308
sudo docker tag $id:$tag $id:$newtag
sudo docker push $id:$newtag
