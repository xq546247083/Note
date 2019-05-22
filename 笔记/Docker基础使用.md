# Docker基础使用

># 一、Docker基础流程

>## 1、拉取一个基础镜像

    docker pull hub.c.163.com/public/centos:7.2.1511

>## 2、以镜像为基础，新建并运行一个容器【84352c4ff678:为镜像ID】

    docker run -p 127.0.0.1:10011:10011 -it 84352c4ff678 /bin/bash

>## 3、不结束容器的退出方式

    CTRL+P+Q

>## 4、再次进入容器的方式【760301b85968 :为容器ID】

    docker exec -it 760301b85968 /bin/bash

>## 5、提交容器为一个新的镜像【760301b85968 :为容器ID】

    docker commit 760301b85968 xq546247083/website

>## 6、为镜像打标签

    docker tag xq546247083/website xq546247083/website:latest

>## 7、推送容器到Docker服务器上

    docker push xq546247083/website:latest

># 二、常用命令

>## 1、复制要运行的文件到容器中【760301b85968 :为容器ID】

    docker cp /Users/xiaoqiang/Code/Go/src/xq.goproject.com/goServer/webSite 760301b85968:/home

>## 2、查看所有镜像

    docker images -a

>## 3、查看所有容器

    docker ps -a

>## 4、删除镜像

    docker rmi 84352c4ff678

>## 5、删除容器【760301b85968 :为容器ID】

    docker rm 760301b85968

>## 6、停止容器【760301b85968 :为容器ID】

    docker stop 760301b85968

>## 7、启动容器【760301b85968 :为容器ID】

    docker start 760301b85968