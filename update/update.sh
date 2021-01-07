#!/bin/sh


# 换源
echo 'deb http://packages.deepin.com/deepin stable main non-free contrib' > /etc/apt/sources.list

apt-get update

# 更新企业版
# apt-get install -y deepin.com.qq.b.eim 
# 更新QQ
apt-get install -y deepin.com.qq.im
# 更新轻聊版
# apt-get install -y deepin.com.qq.im.light 
# 更新TIM
# apt-get install -y deepin.com.qq.office

mv -v /entrypoint.sh.bk /entrypoint.sh



