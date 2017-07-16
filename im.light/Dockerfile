FROM bestwu/wine:i386
MAINTAINER Peter Wu <piterwu@outlook.com>

RUN apt-get update && \
    apt-get install -y deepin.com.qq.im.light && \
    apt-get -y autoremove && apt-get clean -y && apt-get autoclean -y && \
    rm -rf var/lib/apt/lists/* var/cache/apt/* var/log/*

VOLUME ["/TencentFiles"]

ENV APP=QQLight \
    USER=root \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]