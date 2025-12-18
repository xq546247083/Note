# 搭建ES服务

    1、下载地址
        https://www.elastic.co/downloads/past-releases/elasticsearch-8-19-8
    2、配置文件
        见本目录，该文件只能用记事本编译，格式为utf-8
    3、启用HTTPS
        1、生成证书：elasticsearch-certutil ca
        2、生成当前证书的节点证书：elasticsearch-certutil cert --ca 上一步生成证书路径\elastic-stack-ca.p12
        3、添加SSL证书密码：elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
        4、添加SSL证书密码：elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password
        5、把生成的证书拷贝到config目录下
    4、安装ES服务
        elasticsearch-service.bat install
    5、修改密码
        elasticsearch-setup-passwords interactive
    6、访问http://127.0.0.1:9003/
        输入elastic和密码即可访问

# 常用命令

    1、修改密码

        elasticsearch-reset-password --username 用户名 -i