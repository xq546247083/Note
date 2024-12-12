# Docker Wine

    1、linux安装Xvfb
    2、docker attch 进程名
        获取进程的consolse输出

# 显示Wine系统界面

    1、远程Wine所在的虚拟机，终端输入以下命令：
        xhost +
    2、docker exec -it wine这个docker的名称 /bin/bash
        进入docker系统

# 启动程序

    1、wine taskmgr
    2、winedbg