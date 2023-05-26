# Linux远程调试

    1、安装SSH服务，略过。

    2、SSH开启密码登录。
        1、vi /etc/ssh/sshd_config，修改以下信息。
            PasswordAuthentication yes
        2、重启SSH服务
            systemctl restart sshd 或 service sshd restart
           
    3、安装远程调试包（有VS远程调试包的，可跳过此步骤中的2-4）
        1、拷贝本Git项目中本目录中的【GetVsDbg.sh】文件到linux服务上的目录【/root/.vs-debugger】
        2、执行命令：cd /root/.vs-debugger/

        2、执行命令：/bin/sh /root/.vs-debugger/GetVsDbg.sh -v vs2022 -l /root/.vs-debugger/vs2022 -a /remote_debugger
        3、上述命令执行结果中，会打印一句：VS RemoteDebugger DonwLoadUrl:https://vsdebugger.azureedge.net/vsdbg-17-6-10401-3/vsdbg-linux-x64.tar.gz
        4、科学上网，调用URL【https://vsdebugger.azureedge.net/vsdbg-17-6-10401-3/vsdbg-linux-x64.tar.gz】下载该远程调试包

        5、拷贝下载完成的【vsdbg-linux-x64.tar.gz】到linux服务上的目录【/root/.vs-debugger/vs2022】
        6、执行命令：/bin/sh /root/.vs-debugger/GetVsDbg.sh -v vs2022 -l /root/.vs-debugger/vs2022 -a /remote_debugger
        7、得到消息：Successfully installed vsdbg at '/root/.vs-debugger/vs2022'

    4、远程调试
        vs2022远程调试，连接类型选择SSH，添加服务器的信息，用用户名和密码登录。代码类型选择：net core for unix。