#!/bin/bash
docker build -t bestwu/qq:office ./office
docker build -t bestwu/qq:im ./im
docker build -t bestwu/qq:light -t bestwu/qq ./im.light
docker build -t bestwu/qq:eim ./eim