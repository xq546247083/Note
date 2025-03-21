# WinDebug内存溢出分析

    !address -summary
        内存分析
    !heap -s
        堆占用分析
    !heap -l
        检测泄漏的堆块
    !heap -h 00430000
        显示堆的所有块
    !heap -p -h 00430000
        分析堆的内存分配情况
    !heap -stat -h 00430000
        按块大小，统计堆信息
    !heap -flt s 80
        搜索大小为80的堆
    !heap 00430000 -x
    !heap 00430000 -x -v
        命令搜索包含给定地址的堆块。 如果使用了 -v选项，则此命令将另外在当前进程的整个虚拟内存空间中搜索指向此堆块的指针。
    dt nt!_HEAP 00430000 
        查看堆信息

    !heap -p -a 0f2d0360
        查看地址调用堆栈信息
    !heap -srch 0f2d0360
        搜索地址信息
    !gcroot 0f2d0360
        查看地址引用根
    dt ntdll!_DPH_HEAP_ROOT CreateStackTrace 0f2d0360
        查看创建堆栈
    dds 6efda24c
        查看创建堆栈的完全堆栈
    dd 0f2d0360
        查看地址内容

    .logopen d:\log.txt
    .logclose