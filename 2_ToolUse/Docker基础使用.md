# Docker����ʹ��

># һ��Docker��������

>## 1����ȡһ����������

    docker pull hub.c.163.com/public/centos:7.2.1511

>## 2���Ծ���Ϊ�������½�������һ��������84352c4ff678:Ϊ����ID��

    docker run -p 127.0.0.1:10011:10011 -it 84352c4ff678 /bin/bash

>## 3���������������˳���ʽ

    CTRL+P+Q

>## 4���ٴν��������ķ�ʽ��760301b85968 :Ϊ����ID��

    docker exec -it 760301b85968 /bin/bash

>## 5���ύ����Ϊһ���µľ���760301b85968 :Ϊ����ID��

    docker commit 760301b85968 xq546247083/website

>## 6��Ϊ������ǩ

    docker tag xq546247083/website xq546247083/website:latest

>## 7������������Docker��������

    docker push xq546247083/website:latest

># ������������

>## 1������Ҫ���е��ļ��������С�760301b85968 :Ϊ����ID��

    docker cp /Users/xiaoqiang/Code/Go/src/xq.goproject.com/goServer/webSite 760301b85968:/home

>## 2���鿴���о���

    docker images -a

>## 3���鿴��������

    docker ps -a

>## 4��ɾ������

    docker rmi 84352c4ff678

>## 5��ɾ��������760301b85968 :Ϊ����ID��

    docker rm 760301b85968

>## 6��ֹͣ������760301b85968 :Ϊ����ID��

    docker stop 760301b85968

>## 7������������760301b85968 :Ϊ����ID��

    docker start 760301b85968