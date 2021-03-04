[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://hub.docker.com/r/bestwu/qq/)
[![Image Layers and Size](https://images.microbadger.com/badges/image/bestwu/qq.svg)](http://microbadger.com/images/bestwu/qq)

本镜像基于[深度操作系统](https://www.deepin.org/download/)

提供一种在linux下运行QQ的方式

### Supported tags

* im ([QQ 9.1.8](https://github.com/bestwu/docker-qq/blob/master/im/Dockerfile))
* light,latest ([QQLight 7.9](https://github.com/bestwu/docker-qq/blob/master/im.light/Dockerfile))
* office ([TIM 2.0](https://github.com/bestwu/docker-qq/blob/master/office/Dockerfile))
* eim ([EIM 1.9](https://github.com/bestwu/docker-qq/blob/master/eim/Dockerfile))

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

### 更新

进入docker容器：docker exec -it qq bash
运行以下命令更新深度软件包：

```bash
apt-get update


# 更新企业版
# apt-get install -y deepin.com.qq.b.eim 
# 更新QQ
apt-get install -y deepin.com.qq.im
# 更新轻聊版
# apt-get install -y deepin.com.qq.im.light 
# 更新TIM
# apt-get install -y deepin.com.qq.office

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
    ipc: host
    devices:
      - /dev/snd #声音
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /home/peter/TencentFiles:/TencentFiles #使用自己的用户路径
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
    --device /dev/snd --ipc="host"\
    -v $HOME/TencentFiles:/TencentFiles \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e DISPLAY=unix$DISPLAY \
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

### 已知问题

* 界面未显示异常

如果界面未显示，运行：

```bash
docker logs qq
```

如果出现如下错误：

```log
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

* 无声音

请尝试以下配置

```yml
version: '2'
services:
  qq:
    image: bestwu/qq:office
    container_name: qq
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /run/user/1000/pulse/native:/run/user/1000/pulse/native
      - /home/peter/TencentFiles:/TencentFiles
    environment:
      - DISPLAY=unix$DISPLAY
      - PULSE_SERVER=unix:/run/user/1000/pulse/native
      - XDG_RUNTIME_DIR=/run/user/1000
      - QT_IM_MODULE=fcitx
      - XMODIFIERS=@im=fcitx
      - GTK_IM_MODULE=fcitx
      - AUDIO_GID=63 # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
      - GID=$GID # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
      - UID=$UID # 可选 默认1000 主机当前用户 uid 解决挂载目录访问权限问题
```

```bash
  docker run -d --name qq \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v $HOME/TencentFiles:/TencentFiles \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -e XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \
    -e DISPLAY=unix$DISPLAY \
    -e GID=`id -g` \
    -e UID=`id -u` \
    bestwu/qq:office
```

* 非gnome桌面无法显示界面

```
X Error of failed request:  BadWindow (invalid Window parameter)
  Major opcode of failed request:  20 (X_GetProperty)
  Resource id in failed request:  0x0
  Serial number of failed request:  10
  Current serial number in output stream:  10
```
解决方法：安装gnome-settings-daemon，然后运行/usr/lib/gsd-xsettings

* 检测不到摄像头，不能视频

* （TIM）同意加好友申请后崩溃

* Wayland 显示服务器，截图功能异常

* 无法直接点击打开链接

* 无法拖拽发送文件。使用挂载目录方式，点击发送文件按钮，选择文件
