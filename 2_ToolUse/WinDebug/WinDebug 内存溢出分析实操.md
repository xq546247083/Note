# 内存溢出的分析实操

## 在进行运行前，使用gflag设置记录函数调用栈信息,再抓Dump包。具体参考：[本目录文件夹AutoUMDH]

    以管理员权限打开GFlags.exe
        1、打开Image File选项卡
        2、填写Image的值为:Demo.exe，点击Tab
        3、勾选Create user mode stack trace database，点击应用。

## 加载初始环境

    .logopen d:\log.txt
    .sympath srv*C:\symbols*https://msdl.microsoft.com/download/symbols
    !sym noisy
    .cordll -ve -u  -l
    .load SOS.dll
    .load clr.dll
    .load mscordacwks.dll
    .load mscordbi.dll
    .loadby clr sos
    .load wow64exts
    .symfix c:\symbols
    .reload

## 查看是托管堆泄露还是非托管堆泄露

    !address -summary

    Usage Summary是使用情况，按照大小排序。
        通常排第一的不是Heap就是<unkown>。Heap是C++的非托管内存，<unkown>是C#的托管内存。
    Type Summary是类型情况，分了3类，分别是：
        MEM_PRIVATE：当前进程独占的内存。
        MEM_MAPPED：映射到文件的内存，这些文件不属于进程程序本身，比如Memory Mapping File。
        MEM_IMAGE：映射到进程程序的内存，比如程序加载的dll。

## 分析堆情况，推测出泄露的堆的三种方式

    1、直接看大小
        !heap -s
    2、和另一个dump文件对比大小
        !heap -s
    3、检测泄漏的堆块
        !heap -l

## 查询堆情况

    1、按块大小，统计堆信息
        !heap -stat -h 00430000
    2、显示堆的所有块
        !heap -h 00430000
    3、分析堆的内存分配情况
        !heap -p -h 00430000
    4、搜索大小为80的堆
        !heap -flt s 80
        
## 分析地址信息

    1、查看堆栈
        !heap -p -a 0f2d0360
    2、查看数据
        db 0f2d0360
    3、查看引用
        !gcroot 0f2d0360