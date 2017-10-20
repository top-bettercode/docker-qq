[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://hub.docker.com/r/bestwu/qq/)

### Supported tags

* im ([QQ](https://github.com/bestwu/docker-qq/blob/master/im/Dockerfile))
* light,latest ([QQLight](https://github.com/bestwu/docker-qq/blob/master/im.light/Dockerfile))
* office ([TIM](https://github.com/bestwu/docker-qq/blob/master/office/Dockerfile))

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```

## 查看系统组ID

为了使用声音和对应的视频设备，需要具有系统特定组的权限，因此需要获得对应的组ID。

获取 `audio` 组 ID

```bash
$ getent group audio | cut -d: -f3
63
```

这里取得的 `63` 就是 `audio` 组的组 ID，替换下面命令中对应的ID。

获取 `video` 组 ID

```bash
$ getent group video | cut -d: -f3
44
```

### 运行QQ

#### docker-compose

建立 `docker-compose.yml` 文件，内容如下：

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
      - $HOME/TencentFiles:/TencentFiles
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=fcitx #中文输入
      - QT_IM_MODULE=fcitx
      - GTK_IM_MODULE=fcitx
      - AUDIO_GID=63 # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
      - GID=$GID # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      - UID=$UID # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
```

然后在命令行运行：

```bash
docker-compose up -d
```

#### docker run

也可以使用 `docker run` 命令直接在命令行执行：

```bash
  docker run -d --name qq \
    --device /dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/TencentFiles:/TencentFiles \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e VIDEO_GID=`getent group video | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    bestwu/qq:office
```

可以写入一个脚本来方便以后调用。

#### 维护

停止容器

```bash
docker stop qq
```

删除容器

```bash
docker rm qq
```

如果容器没有退出需要强行删除，可以加 `-f` 参数

```bash
docker rm -f qq
```

### 界面未显示异常

如果界面未显示，运行：

```bash
docker logs qq
```

如果出现如下错误：

```bash
X Error of failed request： BadAccess （attempt access private resource ***）
 Major opcode of failed request：130（MIT-SHM)
```

这是因为本地的linux中默认开启了“MIT-SHM”共享X进程内存的功能，禁用该共享功能即可。

具体操作：

```bash
vi /etc/X11/xorg.conf
```

增加：

```bash
 Section "Extensions"
     Option "MIT-SHM" "Disable"
 EndSection
```

重启系统

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
  docker run -d --name xxx \
    --device /dev/snd \
    -v `pwd`/wine:/wine \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    bestwu/qq:office /wine/xxx.exe
```
