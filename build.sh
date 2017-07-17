#!/bin/bash
cd office
docker build -t bestwu/qq:office .
cd ../im
docker build -t bestwu/qq:im .
cd ../im.light
docker build -t bestwu/qq:light -t bestwu/qq .
