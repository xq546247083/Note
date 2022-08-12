#!/bin/sh

# 启动服务
# 1、下载mongod，并解压到本脚本相同的目录
# 2、赋予本脚本执行权限，运行一下命令:chmod +x mongodb.sh 
# 3、本目录创建MongodbData目录，存放数据
# 4、运行本脚本

# 使用MongoDB命令连接服务，创建密码
# 1、下载mongosh
# 2、命令框中输入以下命令：
# 3、mongosh
# 4、use admin
# 5.1、db.createUser({user: 'root', pwd: '123456', roles: ['root']})
# 5.2、db.createUser({ user: "root", pwd: "123456", roles: [{ role: "userAdminAnyDatabase", db: "admin" }] })
# 5、db.auth("root","123456")

# 连接字符串
# ./mongosh "mongodb://root:123456@localhost:27017/admin?authSource=admin"
# ./mongosh --port 27017 -u root -p '123456' --authenticationDatabase 'admin'


sudo ./mongodb/bin/mongod --auth --wiredTigerCacheSizeGB 4 --dbpath ./MongodbData --bind_ip=0.0.0.0