1、开启gflags:

    1、进入Windebug目录，打开gflags.exe程序。
    2、切换到Image File栏目。
    3、在image中，输入内存泄露的进程名:test.exe程序,点击TAB按键，刷新配置。
    4、勾选以下栏目：1、Enable page heap 2、Enable heap tagging 3、Create user mode stack trace database。

2、创建内存对比文件：

    1、重启内存泄露的程序。
    2、管路员权限启动CMD，进入Windebug目录。
    3、创建内存快照1：umdh -p:内存泄露的程序的进程号 -f:log1。
    4、等待程序运行一段时间，泄露内存。
    5、创建内存快照2：umdh -p:内存泄露的程序的进程号 -f:log2。
    6、对比内存快照1和内存快照2，得出泄露内存的对象：umdh -d log1 log2 -f:log.txt。
    7、用记事本打开Windebug目录下面的log.txt,查询内存泄露的对象。

注意：
    1、必须使用debug版本的dll，才能准确定位堆栈。这个可以定位C语言的堆栈。

