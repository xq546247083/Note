# WinDebug�ڴ��������

    !address -summary
        �ڴ����
    !heap -s
        ��ռ�÷���
    !heap -l
        ���й©�Ķѿ�
    !heap -h 00430000
        ��ʾ�ѵ����п�
    !heap -p -h 00430000
        �����ѵ��ڴ�������
    !heap -stat -h 00430000
        �����С��ͳ�ƶ���Ϣ
    !heap -flt s 80
        ������СΪ80�Ķ�
    !heap 00430000 -x
    !heap 00430000 -x -v
        ������������������ַ�Ķѿ顣 ���ʹ���� -vѡ������������ڵ�ǰ���̵����������ڴ�ռ�������ָ��˶ѿ��ָ�롣
    dt nt!_HEAP 00430000 
        �鿴����Ϣ

    !heap -p -a 0f2d0360
        �鿴��ַ���ö�ջ��Ϣ
    !heap -srch 0f2d0360
        ������ַ��Ϣ
    !gcroot 0f2d0360
        �鿴��ַ���ø�
    dt ntdll!_DPH_HEAP_ROOT CreateStackTrace 0f2d0360
        �鿴������ջ
    dds 6efda24c
        �鿴������ջ����ȫ��ջ
    dd 0f2d0360
        �鿴��ַ����

    .logopen d:\log.txt
    .logclose