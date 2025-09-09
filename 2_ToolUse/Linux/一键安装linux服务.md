# һ����װlinux������

## 1.����������.service���ļ�

    �� /etc/systemd/system/ Ŀ¼�´���һ����Ϊ ������.service�� ���ļ�����ʹ���ı��༭���򿪲�����������ݣ�

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

## 2.���ú���������

    sudo systemctl enable ������.service��
    sudo systemctl start ������.service��
    sudo systemctl status ������.service��
    sudo systemctl stop ������.service��
    sudo systemctl restart ������.service��