# Linux远程调试

    1、安装SSH服务

    2、SSH开启密码登录
        1、vi /etc/ssh/sshd_config，修改以下信息
            PasswordAuthentication yes
            PermitRootLogin yes
        2、重启SSH服务
            systemctl restart sshd或
            service sshd restart
            
    3、获取远程调试包

    4、安装远程调试包

    3、部署远程调试环境
        1、拷贝本目录的【GetVsDbg.sh】文件到linux服务上的【/root/.vs-debugger】。
        2、从ULR【https://vsdebugger.azureedge.net/vsdbg-17-6-10401-3/vsdbg-linux-x64.tar.gz】中下载vs远程调试包。
        3、拷贝下载完成的【vsdbg-linux-x64.tar.gz】文件到linux服务上的【/root/.vs-debugger/vs2022】.

    5、远程调试
        vs2022远程调试，连接类型选择SSH，添加服务器的信息，用用户名和密码登录。
        
