### Supported tags

* im ([QQ](https://github.com/bestwu/docker-qq/blob/master/im/Dockerfile))
* light,latest ([QQLight](https://github.com/bestwu/docker-qq/blob/master/im.light/Dockerfile))
* office ([TIM](https://github.com/bestwu/docker-qq/blob/master/office/Dockerfile))

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```

## 查看系统audio gid

```bash
  cat /etc/group | grep audio
```

fedora 26 结果：

```bash
audio:x:63:
```

### 运行QQ

### docker-compose

```yml
version: '2'
services:
  qq:
    image: bestwu/qq:office
    container_name: qq
    devices:
      - /dev/snd #声音
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /home/peter/TencentFiles:/TencentFiles
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=fcitx #中文输入
      - QT_IM_MODULE=fcitx
      - GTK_IM_MODULE=fcitx
      - AUDIO_GID=63 # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
      - GID=1000 # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      - UID=1000 # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
```

或

```bash
    docker run -d --name qq --device /dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/peter/TencentFiles:/TencentFiles \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=63 \
    -e GID=1000 \
    -e UID=1000 \
    bestwu/qq:office
```

### 运行其他wine 程序

```yml
version: '2'
services:
  xxx:
    image: bestwu/qq:office
    container_name: xxx
    devices:
      - /dev/snd
    volumes:
      - ./wine:/wine
      - /tmp/.X11-unix:/tmp/.X11-unix
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=fcitx
      - QT_IM_MODULE=fcitx
      - GTK_IM_MODULE=fcitx
    command: /wine/xxx.exe
```

或

```bash
    docker run -d --name xxx --device /dev/snd \
    -v `pwd`/wine:/wine \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    bestwu/qq:office /wine/xxx.exe
```
