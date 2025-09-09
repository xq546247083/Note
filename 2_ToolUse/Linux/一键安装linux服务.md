# 一键安装linux服务步骤

## 1.创建【服务.service】文件

    在 /etc/systemd/system/ 目录下创建一个名为 【服务.service】 的文件，并使用文本编辑器打开并添加以下内容：

```shell
    [Unit]
    Description=XingShu.Aegis.Web
    After=network.target

    [Service]
    WorkingDirectory=/home/aegis/
    ExecStart=./XingShu.Aegis.Web
    Restart=always
    RestartSec=5
    StartLimitInterval=0

    [Install]
    WantedBy=multi-user.target
```

## 2.启用和启动服务

    sudo systemctl enable 【服务.service】
    sudo systemctl start 【服务.service】
    sudo systemctl status 【服务.service】
    sudo systemctl stop 【服务.service】
    sudo systemctl restart 【服务.service】