#!/bin/bash
docker build -t bestwu/qq:office -f office/Dockerfile .
docker build -t bestwu/qq:im -f im/Dockerfile .
docker build -t bestwu/qq:light -t bestwu/qq -f im.light/Dockerfile .
docker build -t bestwu/qq:eim -f eim/Dockerfile .
