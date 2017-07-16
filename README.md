
镜像包含wine,可使用此镜像运行其他wine程序

### 准备工作

允许所有用户访问X11服务,运行命令:

```bash
    xhost +
```
### 运行QQ

### docker-compose 

```yml
version: '2'
services:
  qq:
    image: bestwu/qq:office
    container_name: qq
    network_mode: "host"
    restart: always
    devices:
      - /dev/snd #声音
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /home/peter/TencentFiles:/TencentFiles
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=ibus #中文输入 fcitx输入法：XMODIFIERS=@im=fcitx
      - QT_IM_MODULE=ibus
      - GTK_IM_MODULE=ibus
      - USER=peter # 以非root自定义账号运行，解决接收到的文件在挂载目录的权限问题
```
或

```bash
    docker run -d --name qq --restart=always --device /dev/snd --net=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/peter/TencentFiles:/TencentFiles \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=ibus \
    -e QT_IM_MODULE=ibus \
    -e GTK_IM_MODULE=ibus \
    -e USER=peter \
    bestwu/qq:office
```

### 运行其他wine 程序

```yml
version: '2'
services:
  qq:
    image: bestwu/qq:office
    container_name: qq
    network_mode: "host"
    restart: always
    devices:
      - /dev/snd #声音
    volumes:
      - ./wine:/wine
      - /tmp/.X11-unix:/tmp/.X11-unix
    environment:
      - DISPLAY=unix$DISPLAY
      - XMODIFIERS=@im=ibus #中文输入 fcitx输入法：XMODIFIERS=@im=fcitx
      - QT_IM_MODULE=ibus
      - GTK_IM_MODULE=ibus
    command: /wine/xxx.exe
```

或

```bash
    docker run -d --name qq --restart=always --device /dev/snd --net=host \
    -v `pwd`/wine:/wine \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=ibus \
    -e QT_IM_MODULE=ibus \
    -e GTK_IM_MODULE=ibus \
    bestwu/qq:office /wine/xxx.exe
```


### 开机启动

重启后 xhost + 失效的解决方法

禁用docker的自动重启

```bash
systemctl disable docker

```
在xsession中添加启动脚本

```bash
xhost +
echo 'sudopassword' |sudo -S  systemctl start docker
```
