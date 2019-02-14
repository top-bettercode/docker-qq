FROM bestwu/wine:i386
LABEL maintainer='Peter Wu <piterwu@outlook.com>'

RUN apt-get update && \
    apt-get install -y --no-install-recommends deepin.com.qq.im.light && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

ENV APP=QQLight \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

RUN groupadd -o -g $GID qq && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/qq" -m -o -u $UID -g qq -G audio,video qq && \
    mkdir /TencentFiles && \
    chown -R qq:qq /TencentFiles && \
    ln -s "/TencentFiles" "/home/qq/Tencent Files" && \
    sed -i 's/CallApp$/sed -i "s\/QQ.exe\\" \&\/QQ.exe\\"\/g" "\/home\/qq\/.deepinwine\/Deepin-QQLight\/drive_c\/deepin\/EnvInit.sh"\n 	rm \/home\/qq\/.deepinwine\/Deepin-QQLight\/drive_c\/deepin\/first\n        CallApp\n/g' "/opt/deepinwine/apps/Deepin-$APP/run.sh"


VOLUME ["/TencentFiles"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]